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
    public let headerDay: HeaderDay
    public let dkHeader: DKHeader?
    public let tripData: TripData

    public init(tripsByDate: [DKTripsByDate], headerDay: HeaderDay, dkHeader: DKHeader?, tripData: TripData) {
        self.tripsByDate = tripsByDate
        self.headerDay = headerDay
        self.dkHeader = dkHeader
        self.tripData = tripData
    }

    public func updateTrips(tripsByDate: [DKTripsByDate]) {
        self.tripsByDate = tripsByDate
    }
}
