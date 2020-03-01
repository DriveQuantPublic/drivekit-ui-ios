//
//  ShortTripPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess

class ShortTripPageViewModel {
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    var timeSlotLabelText: String {
        return "\(trip.tripStartDate.format(pattern: .hourMinuteLetter)) - \(trip.tripEndDate.format(pattern: .hourMinuteLetter))"
    }
}
