//
//  TripListViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverDataModule
import DriveKitDBTripAccessModule
import DriveKitCommonUI
import UIKit

class TripListViewModel {
    private var trips : [TripsByDate] = []
    var filteredTrips : [TripsByDate] = []
    var status: TripSyncStatus = .noError
    private(set) var listConfiguration: TriplistConfiguration = .motorized(nil)
    
    weak var delegate: TripsDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTrips()
            }
        }
    }
    
    var tripNumber :Int {
        return self.filteredTrips.map { $0.trips.count }.reduce(0, +)
    }
    
    var tripsDistance : Double {
        return self.filteredTrips.map {$0.trips.map {($0.tripStatistics?.distance ?? 0)}.reduce(0, +)}.reduce(0, +).metersToKilometers(places: 0)
    }
    
    public func fetchTrips() {
        var transportationModes = self.listConfiguration.transportationModes()
        if DriveKitDriverDataUI.shared.enableAlternativeTrips {
            transportationModes.append(contentsOf: TriplistConfiguration.alternative(nil).transportationModes())
        }
        DriveKitDriverData.shared.getTripsOrderByDateDesc(withTransportationModes: transportationModes, completionHandler: {status, trips in
            DispatchQueue.main.async {
                self.status = status
                self.trips = self.sortTrips(trips: trips)
                self.filterTrips(config: self.listConfiguration)
                self.delegate?.onTripsAvailable()
            }
        })
    }
    
    private func sortTrips(trips : [Trip]) -> [TripsByDate] {
        let tripSorted = trips.orderByDay(descOrder: DriveKitDriverDataUI.shared.dayTripDescendingOrder)
        return tripSorted
    }
    
    
    
    func getTripListFilterItems() -> [DKFilterItem] {
        var items = [TriplistConfiguration.motorized(nil)]
        if DriveKitDriverDataUI.shared.enableAlternativeTrips {
            items.append(TriplistConfiguration.alternative(nil))
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
    
    private func getVehicleFilterItems() -> [DKFilterItem]?{
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
        let standardTransportationModes: [TransportationMode] = TriplistConfiguration.motorized(nil).transportationModes()
        let alternativeTransportationModes: [TransportationMode] = TriplistConfiguration.alternative(nil).transportationModes()
        for transportationMode in standardTransportationModes {
            let numberOfTrips = DriveKitDBTripAccess.shared.tripsQuery().whereEqualTo(field: "declaredTransportationMode.transportationMode", value: Int32(transportationMode.rawValue)).query().execute().count
            if numberOfTrips > 0 {
                modes.append(transportationMode)
            }
        }
        for alternativeTransportationMode in alternativeTransportationModes {
            let numberOfTrips = DriveKitDBTripAccess.shared.tripsQuery().whereEqualTo(field: "declaredTransportationMode.transportationMode", value: Int32(alternativeTransportationMode.rawValue)).or().whereEqualTo(field: "transportationMode", value: Int32(alternativeTransportationMode.rawValue)).query().execute().count
            if numberOfTrips > 0 {
                modes.append(alternativeTransportationMode)
            }
        }
        modes.insert(AllAlternativeMode(), at: 0)
        return modes
    }
    
    func filterTrips(config: TriplistConfiguration) {
        self.listConfiguration = config
        switch config {
            case .motorized(let vehicleId):
                self.filterTrips(vehicleId: vehicleId)
            case .alternative(let transportationMode):
                self.filterTrips(transportationMode: transportationMode)
        }
    }
    
    private func filterTrips(vehicleId : String?) {
        if let vehicleId = vehicleId {
            self.filterTrips {$0.vehicleId == vehicleId}
        }else{
            let motorizedModes = TriplistConfiguration.motorized(nil).transportationModes()
            self.filterTrips { motorizedModes.contains(TransportationMode(rawValue: Int(($0 as Trip).transportationMode)) ?? TransportationMode.unknown) }
        }
    }
    
    private func filterTrips(transportationMode: TransportationMode?) {
        if let transportationMode = transportationMode {
            self.filterTrips {$0.transportationMode == transportationMode.rawValue}
        }else{
            let alternativeModes = TriplistConfiguration.alternative(nil).transportationModes()
            self.filterTrips { alternativeModes.contains(TransportationMode(rawValue: Int(($0 as Trip).transportationMode)) ?? TransportationMode.unknown) }
        }
    }
    
    private func filterTrips(_ isIncluded : (Trip) -> Bool) {
        self.filteredTrips = []
        for tripsByDate in self.trips {
            let dayFilterdTrips = tripsByDate.trips.filter(isIncluded)
            if dayFilterdTrips.count > 0 {
                self.filteredTrips.append(TripsByDate(date: tripsByDate.date, trips: dayFilterdTrips))
            }
        }
    }
    
    func hasTrips() -> Bool {
        return trips.count > 0
    }
    
    func getTripInfo() -> DKTripInfo? {
        switch listConfiguration {
            case .motorized(_):
                return DriveKitDriverDataUI.shared.customTripInfo ?? AdviceTripInfo()
            case .alternative(_):
                return nil
        }
    }
}

protocol TripsDelegate : AnyObject {
    func onTripsAvailable()
}

class AllTripFilterItem : DKFilterItem {
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

class AllAlternativeMode : DKFilterItem {
    func getImage() -> UIImage? {
        return UIImage(named: "dk_transportation_all", in: Bundle.driverDataUIBundle, compatibleWith: nil)
    }
    
    func getName() -> String {
        return "dk_driverdata_alternative_trips".dkDriverDataLocalized()
    }
    
    func getId() -> Any? {
        return self
    }
}
