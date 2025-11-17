//
//  FindMyVehicleViewModel.swift
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

class FindMyVehicleViewModel: NSObject {
    let lastLocationCoordinates: CLLocationCoordinate2D?
    let lastLocationDate: Date?
    let shouldDrawAccuracyCircle: Bool
    private let lastlocationAccuracy: Double?
    private(set) var userLocationCoordinates: CLLocationCoordinate2D?
    private(set) var addressString: String?
    private(set) var polyLine: MKPolyline?
     
    weak var delegate: FindMyVehicleViewModelDelegate?
    private let locationManager: CLLocationManager = CLLocationManager()

    var accuracyCircleRadius: Double {
        guard let lastlocationAccuracy else { return 0 }
        return min(100, lastlocationAccuracy)
    }

    override init() {
        if let lastLocation = DriveKitTripAnalysis.shared.getLastTripLocation() {
            self.lastLocationCoordinates = CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
            self.lastLocationDate = lastLocation.date
            self.lastlocationAccuracy = lastLocation.accuracyMeter
            self.shouldDrawAccuracyCircle = lastLocation.getAccuracyLevel() == .poor
        } else {
            self.lastLocationCoordinates = nil
            self.lastLocationDate = nil
            self.lastlocationAccuracy = nil
            self.shouldDrawAccuracyCircle = false
        }
        self.userLocationCoordinates = CLLocationManager().location?.coordinate
    }

    func retrieveLastLocationAddress() {
        if let lastLocationCoordinates = self.lastLocationCoordinates {
            ReverseGeocoder().getAddress(location: CLLocation(latitude: lastLocationCoordinates.latitude, longitude: lastLocationCoordinates.longitude)) { address in
                if let address {
                    self.addressString = address.address?.replacingOccurrences(of: ",", with: "\n") ?? "\(address.postalCode) \(address.city)"
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
            self.delegate?.directionsRequestFinished()
            return
        }

        let maxDistanceToRequestDirections: Double = 1_000
        guard let distance = getDistance(), distance <= maxDistanceToRequestDirections else {
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
            let veryCloseDistanceLimit: Double = 100
            if distance < veryCloseDistanceLimit {
                return String(format: "dk_find_vehicle_location_very_close".dkVehicleLocalized(), "\(Int(veryCloseDistanceLimit))")
            } else if distance < kmDistanceLimit {
                return String(format: "dk_find_vehicle_location_nearby".dkVehicleLocalized(), "\(Int(distance.roundNearest(step: 100)))")
            } else {
                let kmDistance = Measurement(value: distance, unit: UnitLength.meters).converted(to: .kilometers).value
                return String(format: "dk_find_vehicle_location_far".dkVehicleLocalized(), "\(Int(kmDistance.rounded(.toNearestOrAwayFromZero)))")
            }
        } else /*if DriveKitUI.shared.unitSystem == .imperial*/ {
            let milesDistanceLimit: Double = 1_700
            let veryCloseDistanceLimit: Double = 100
            if yardsDistance < veryCloseDistanceLimit {
                return String(format: "dk_find_vehicle_location_very_close_imperial".dkVehicleLocalized(), "\(Int(veryCloseDistanceLimit))")
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

extension FindMyVehicleViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            self.userLocationCoordinates = coordinates
            locationManager.delegate = nil
            delegate?.userLocationUpdateFinished()
            self.retrieveDirections()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        delegate?.userLocationUpdateFinished()
    }
}
