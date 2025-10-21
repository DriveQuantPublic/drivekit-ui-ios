//
//  ShortTripPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule

class ShortTripPageViewModel {
    var trip: DKTrip
    
    init(trip: DKTrip) {
        self.trip = trip
    }
    
    var timeSlotLabelText: String {
        return "\(trip.tripStartDate.format(pattern: .hourMinute)) - \(trip.tripEndDate.format(pattern: .hourMinute))"
    }
}
