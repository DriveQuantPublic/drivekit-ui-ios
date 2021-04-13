//
//  TripsListViewModel.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 12/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public class TripsListViewModel {
    private(set) var tripsByDate : [DKTripsByDate] = []
    private(set) var tripList: DKTripsList?

    public init(tripsByDate: [DKTripsByDate], tripList: DKTripsList) {
        self.tripsByDate = tripsByDate
        self.tripList = tripList
    }

    public func updateTrips(tripsByDate: [DKTripsByDate]) {
        self.tripsByDate = tripsByDate
    }
}
