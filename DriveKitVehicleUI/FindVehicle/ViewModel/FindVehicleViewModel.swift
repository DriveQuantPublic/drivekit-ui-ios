//
//  FindVehicleViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 05/11/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import CoreLocation
import MapKit
import DriveKitCommonUI

class FindVehicleViewModel: NSObject {
    let lastLocationCoordinates: CLLocationCoordinate2D?
    let lastLocationDate: Date?
    private let lastlocationAccuracy: Double?
    private(set) var userLocationCoordinates: CLLocationCoordinate2D?
    private(set) var addressString: String?
    private(set) var polyLine: MKPolyline?

    weak var delegate: FindVehicleViewModelDelegate?
    private let locationManager: CLLocationManager = CLLocationManager()
    
    var shouldDrawAccuracyCircle: Bool {
        guard let lastlocationAccuracy else { return false }
        let poorAccuracyLimit: Double = 30
        return lastlocationAccuracy > poorAccuracyLimit
    }

    var accuracyCircleRadius: Double {
        guard let lastlocationAccuracy else { return 0 }
        return min(100, lastlocationAccuracy)
    }

    override init() {
        if let lastLocation = DriveKitTripAnalysis.shared.getLastTripLocation() {
            self.lastLocationCoordinates = CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
            self.lastLocationDate = lastLocation.date
            self.addressString = "\(lastLocation.latitude), \(lastLocation.longitude)"
            self.lastlocationAccuracy = lastLocation.accuracyMeter
        } else {
            self.lastLocationCoordinates = nil
            self.lastLocationDate = nil
            self.lastlocationAccuracy = nil
        }
        self.userLocationCoordinates = CLLocationManager().location?.coordinate
    }

    func retrieveLastLocationAddress() {
        if let lastLocationCoordinates = self.lastLocationCoordinates {
            ReverseGeocoder().getAddress(location: CLLocation(latitude: lastLocationCoordinates.latitude, longitude: lastLocationCoordinates.longitude)) { address in
                if let address {
                    self.addressString = address.address ?? "\(address.postalCode), \(address.city)"
                }
                self.delegate?.addressGeocodingFinished()
            }
        } else {
            self.delegate?.addressGeocodingFinished()
        }
    }

    func retrieveUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }

    private func retrieveDirections() {
        guard !shouldDrawAccuracyCircle else {
            // accuracy is poor, draw a line instead
            self.delegate?.directionsRequestFinished()
            return
        }

        let maxDistanceToRequestDirections: Double = 1_000
        guard let distance = getDistance(), distance <= maxDistanceToRequestDirections else {
            // too far from destination, draw a line instead
            self.delegate?.directionsRequestFinished()
            return
        }
        
        guard let lastLocationCoordinates = lastLocationCoordinates, let userLocationCoordinates = userLocationCoordinates else { return }
        let directionRequest = MKDirections.Request()
        directionRequest.source = getMapItem(for: userLocationCoordinates)
        directionRequest.destination = getMapItem(for: lastLocationCoordinates)
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)

        directions.calculate { response, error in
            guard let response = response, let route = response.routes.first else {
                if let error = error {
                    DriveKitLog.shared.errorLog(tag: DriveKitVehicleUI.tag, message: "Directions request failed with error: \(error)")
                }
                self.delegate?.directionsRequestFinished()
                return
            }
            self.polyLine = route.polyline
            self.delegate?.directionsRequestFinished()
        }
    }

    private func getMapItem(for coordinates: CLLocationCoordinate2D) -> MKMapItem {
        if #available(iOS 26.0, *) {
            return MKMapItem(location: CLLocation(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            ), address: nil)
        } else {
            return MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        }
    }

    func getDateLabelText() -> String {
        guard let date = lastLocationDate else { return "" }
        return String(format: "dk_find_vehicle_date".dkVehicleLocalized(), date.format(pattern: .standardDate), date.format(pattern: .hourMinute))
    }

    func getDistance() -> Double? {
        guard let lastLocationCoordinates = lastLocationCoordinates, let userLocationCoordinates = userLocationCoordinates else { return nil }
        return CLLocation(latitude: userLocationCoordinates.latitude, longitude: userLocationCoordinates.longitude)
        .distance(from: CLLocation(latitude: lastLocationCoordinates.latitude, longitude: lastLocationCoordinates.longitude))
    }

    func getDistanceLabelText() -> String {
        guard let distance = getDistance() else { return "" }
        let yardsDistance = Measurement(value: distance, unit: UnitLength.meters).converted(to: .yards).value
        if DriveKitUI.shared.unitSystem == .metric {
            let kmDistanceLimit: Double = 950
            if distance < 100 {
                return "dk_find_vehicle_location_very_close".dkVehicleLocalized()
            } else if distance < kmDistanceLimit {
                return String(format: "dk_find_vehicle_location_nearby".dkVehicleLocalized(), "\(Int(distance.roundNearest(step: 100)))")
            } else {
                let kmDistance = Measurement(value: distance, unit: UnitLength.meters).converted(to: .kilometers).value
                return String(format: "dk_find_vehicle_location_far".dkVehicleLocalized(), "\(Int(kmDistance.rounded(.toNearestOrAwayFromZero)))")
            }
        } else /*if DriveKitUI.shared.unitSystem == .imperial*/ {
            let milesDistanceLimit: Double = 1_700
            if yardsDistance < 100 {
                return "dk_find_vehicle_location_very_close_imperial".dkVehicleLocalized()
            } else if yardsDistance < milesDistanceLimit {
                return String(format: "dk_find_vehicle_location_nearby_imperial".dkVehicleLocalized(), "\(Int(yardsDistance.roundNearest(step: 100)))")
            } else {
                let milesDistance = Measurement(value: distance, unit: UnitLength.meters).converted(to: .miles).value
                return String(format: "dk_find_vehicle_location_far_imperial".dkVehicleLocalized(), "\(Int(milesDistance.rounded(.toNearestOrAwayFromZero)))")
            }
        }
    }

    func openItineraryApp() {
        guard let lastLocationCoordinates = lastLocationCoordinates else { return }
        let destinationMapItem = getMapItem(for: lastLocationCoordinates)
        destinationMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
}

extension FindVehicleViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            self.userLocationCoordinates = coordinates
            locationManager.delegate = nil
            delegate?.userLocationUpdateFinished()
            self.retrieveDirections()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // call delegate callback
        delegate?.userLocationUpdateFinished()
    }
}
