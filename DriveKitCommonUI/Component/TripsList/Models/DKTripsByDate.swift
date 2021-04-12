//
//  TripsByDate.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public class DKTripsByDate {
    public var date: Date
    public var trips: [DKTripsListItem]
    
    public init(date: Date, trips: [DKTripsListItem]) {
        self.date = date
        self.trips = trips
    }
}
