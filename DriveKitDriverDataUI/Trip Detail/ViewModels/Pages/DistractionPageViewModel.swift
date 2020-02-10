//
//  DistractionPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess
import CoreLocation

class DistractionPageViewModel {
    var scoreType: ScoreType = .distraction
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }
}
