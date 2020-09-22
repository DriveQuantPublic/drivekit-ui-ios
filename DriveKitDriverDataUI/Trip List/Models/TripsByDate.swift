//
//  TripsByDate.swift
//  drivekit-driverdata
//
//  Created by Meryl Barantal on 19/06/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

public class TripsByDate {
    public var date: Date
    public var trips: [Trip]
    
    init(date: Date, trips: [Trip]) {
        self.date = date
        self.trips = trips
    }
}
