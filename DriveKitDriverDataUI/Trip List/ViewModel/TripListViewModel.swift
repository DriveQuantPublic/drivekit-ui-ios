//
//  TripListViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverDataModule
import DriveKitDBTripAccessModule
import DriveKitCommonUI
import DriveKitCoreModule

class TripListViewModel {
    private var trips: [DKTripsByDate] = []
    var filteredTrips: [DKTripsByDate] = []
    var status: TripSyncStatus = .noError
    private(set) var listConfiguration: TripListConfiguration = .motorized()
    
    weak var delegate: TripsDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTrips()
            }
        }
    }
    
    var tripNumber: Int {
        return self.filteredTrips.map { $0.trips.count }.reduce(0, +)
    }
    
    var tripsDistance: Double {
        return self.filteredTrips.map {$0.trips.map {($0.getDistance() ?? 0)}.reduce(0, +)}.reduce(0, +)
    }

    public func fetchTrips(withSynchronizationType synchronizationType: SynchronizationType = .defaultSync) {
        var transportationModes = TripListConfiguration.motorized().transportationModes()
        if DriveKitDriverDataUI.shared.enableAlternativeTrips {
            transportationModes.append(contentsOf: TripListConfiguration.alternative().transportationModes())
        }
        DriveKitDriverData.shared.getTripsOrderByDateDesc(withTransportationModes: transportationModes, type: synchronizationType, completionHandler: { status, trips in
            DispatchQueue.main.async {
                self.status = status
                self.trips = self.sortTrips(trips: trips)
                self.filterTrips(config: self.listConfiguration)
                self.delegate?.onTripsAvailable()
            }
        })
    }

    private func sortTrips(trips: [Trip]) -> [DKTripsByDate] {
        let tripSorted = trips.orderByDay(descOrder: DriveKitDriverDataUI.shared.dayTripDescendingOrder)
        return tripSorted
    }


    func showFilter() -> Bool {
        switch self.listConfiguration {
            case .motorized:
                return DriveKitDriverDataUI.shared.enableVehicleFilter
            case .alternative:
                return true
        }
    }

    func getTripListFilterItems() -> [DKFilterItem] {
        var items = [TripListConfiguration.motorized()]
        if DriveKitDriverDataUI.shared.enableAlternativeTrips {
            items.append(TripListConfiguration.alternative())
        }
        return items
    }
    
    func getTripFilterItem() -> [DKFilterItem]? {
        switch self.listConfiguration {
            case .motorized(_):
                return self.getVehicleFilterItems()
            case .alternative(_):
                return self.getAlternativeTripsFilterItem()
        }
    }
    
    private func getVehicleFilterItems() -> [DKFilterItem]? {
        if let vehiculeUI = DriveKitNavigationController.shared.vehicleUI {
            var items = vehiculeUI.getVehicleFilterItems()
            items.insert(AllTripFilterItem(), at: 0)
            return items
        } else {
            return nil
        }
    }
    
    private func getAlternativeTripsFilterItem() -> [DKFilterItem]? {
        var modes = [DKFilterItem]()
        let standardTransportationModes: [TransportationMode] = TripListConfiguration.motorized().transportationModes()
        let alternativeTransportationModes: [TransportationMode] = TripListConfiguration.alternative().transportationModes()
        for transportationMode in standardTransportationModes {
            let numberOfTrips = DriveKitDBTripAccess.shared.tripsQuery().whereEqualTo(field: "declaredTransportationMode.transportationMode", value: Int32(transportationMode.rawValue)).query().execute().count
            if numberOfTrips > 0 {
                modes.append(transportationMode)
            }
        }
        for alternativeTransportationMode in alternativeTransportationModes {
            var numberOfTrips = DriveKitDBTripAccess.shared.tripsQuery().whereEqualTo(field: "declaredTransportationMode.transportationMode", value: Int32(alternativeTransportationMode.rawValue)).query().execute().count
            if numberOfTrips == 0 {
                numberOfTrips = DriveKitDBTripAccess.shared.tripsQuery().whereNil(field: "declaredTransportationMode").and().whereEqualTo(field: "transportationMode", value: Int32(alternativeTransportationMode.rawValue)).query().execute().count
            }
            if numberOfTrips > 0 {
                modes.append(alternativeTransportationMode)
            }
        }
        modes.insert(AllAlternativeMode(), at: 0)
        return modes
    }
    
    func filterTrips(config: TripListConfiguration) {
        self.listConfiguration = config
        switch config {
            case .motorized(let vehicleId):
                self.filterTrips(vehicleId: vehicleId)
            case .alternative(let transportationMode):
                self.filterTrips(transportationMode: transportationMode)
        }
    }
    
    private func filterTrips(vehicleId: String?) {
        if let vehicleId = vehicleId {
            self.filterTrips { $0.vehicleId == vehicleId }
        } else {
            self.filterTrips { !$0.isAlternative() }
        }
    }
    
    private func filterTrips(transportationMode: TransportationMode?) {
        if let transportationMode = transportationMode {
            self.filterTrips {
                if let declaredMode = $0.declaredTransportationModeInt {
                    return declaredMode == transportationMode.rawValue
                } else if transportationMode.isAlternative() {
                    return $0.transportationMode == transportationMode.rawValue
                } else {
                    return false
                }
            }
        } else {
            if let alternativeTripsDepthInDays = DriveKitDriverDataUI.shared.alternativeTripsDepthInDays, alternativeTripsDepthInDays >= 0 {
                let limitDate = Date().addingTimeInterval(Double(-alternativeTripsDepthInDays * 24 * 3600))
                self.filterTrips { trip in
                    return trip.isAlternative() && trip.tripEndDate.compare(limitDate) == .orderedDescending
                }
            } else {
                self.filterTrips { trip in
                    return trip.isAlternative()
                }
            }
        }
    }
    
    private func filterTrips(_ isIncluded: (Trip) -> Bool) {
        self.filteredTrips = []
        for tripsByDate in self.trips {
            if let trips = tripsByDate.trips as? [Trip] {
                let dayFilteredTrips = trips.filter(isIncluded)
                if dayFilteredTrips.count > 0 {
                    self.filteredTrips.append(DKTripsByDate(date: tripsByDate.date, trips: dayFilteredTrips))
                }
            }
        }
    }
    
    func hasTrips() -> Bool {
        return trips.count > 0
    }
    
    func hasAlternativeTrips() -> Bool {
        for tripsByDate in self.trips {
            if tripsByDate.trips.first(where: { tripItem in
                tripItem.isAlternative()
            }) != nil {
                return true
            }
        }
        return false
    }
}

protocol TripsDelegate: AnyObject {
    func onTripsAvailable()
}

class AllTripFilterItem: DKFilterItem {
    func getImage() -> UIImage? {
        return UIImage(named: "dk_my_trips", in: Bundle.driverDataUIBundle, compatibleWith: nil)
    }
    
    func getName() -> String {
        return "dk_driverdata_default_filter_item".dkDriverDataLocalized()
    }
    
    func getId() -> Any? {
        return nil
    }
}

class AllAlternativeMode: DKFilterItem {
    func getImage() -> UIImage? {
        return DKDriverDataImages.transportationAll.image
    }
    
    func getName() -> String {
        return "dk_driverdata_default_filter_item".dkDriverDataLocalized()
    }
    
    func getId() -> Any? {
        return self
    }
}
