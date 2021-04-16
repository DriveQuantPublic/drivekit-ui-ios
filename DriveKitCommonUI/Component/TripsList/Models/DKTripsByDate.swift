//
//  TripsByDate.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public struct DKTripsByDate {
    public let date: Date
    public let trips: [DKTripListItem]
    
    public init(date: Date, trips: [DKTripListItem]) {
        self.date = date
        self.trips = trips
    }
}
