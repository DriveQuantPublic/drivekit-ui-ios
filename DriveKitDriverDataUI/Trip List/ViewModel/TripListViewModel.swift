//
//  TripListViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData

class TripListViewModel {
    var trips : [TripsByDate] = []
    var dayTripDescendingOrder: Bool
    var status: TripSyncStatus = .noError
    var delegate: TripsDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTrips()
            }
        }
    }
    
    public init(dayTripDescendingOrder: Bool) {
        self.dayTripDescendingOrder = dayTripDescendingOrder
    }
    
    public func fetchTrips() {
        DriveKitDriverData.shared.getTripsOrderByDateDesc(completionHandler: {status, trips in
            self.status = status
            self.trips = self.sortTrips(trips: trips)
            self.delegate?.onTripsAvailable()
        })
    }
    
    
    func sortTrips(trips : [Trip]) -> [TripsByDate] {
        let tripSorted = trips.orderByDay(descOrder: dayTripDescendingOrder)
        return tripSorted
    }
}

protocol TripsDelegate {
    func onTripsAvailable()
}
