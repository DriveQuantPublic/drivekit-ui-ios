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
        DriveKitDriverData.shared.getTripsOrderByDateDesc(completionHandler: {status, trips in
            DispatchQueue.main.async {
                self.status = status
                self.trips = self.sortTrips(trips: trips)
                self.filteredTrips = self.trips
                self.delegate?.onTripsAvailable()
            }
        })
    }
    
    func sortTrips(trips : [Trip]) -> [TripsByDate] {
        let tripSorted = trips.orderByDay(descOrder: DriveKitDriverDataUI.shared.dayTripDescendingOrder)
        return tripSorted
    }
    
    func getVehicleFilterItems() -> [DKFilterItem]?{
        if let vehiculeUI = DriveKitNavigationController.shared.vehicleUI {
            var items = vehiculeUI.getVehicleFilterItems()
            items.insert(AllTripFilterItem(), at: 0)
            return items
        } else {
            return nil
        }
    }
    
    func filterTrips(vehicleId : String?) {
        if let vehicleId = vehicleId {
            self.filteredTrips = []
            for tripsByDate in self.trips {
                let dayFilterdTrips = tripsByDate.trips.filter {$0.vehicleId == vehicleId}
                if dayFilterdTrips.count > 0 {
                    self.filteredTrips.append(TripsByDate(date: tripsByDate.date, trips: dayFilterdTrips))
                }
            }
        }else{
            self.filteredTrips = self.trips
        }
    }
    
    func hasTrips() -> Bool {
        return trips.count > 0
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
