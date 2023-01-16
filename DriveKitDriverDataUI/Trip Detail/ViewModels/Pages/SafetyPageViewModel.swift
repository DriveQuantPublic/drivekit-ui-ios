//
//  SafetyPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import CoreLocation
import DriveKitCommonUI

class SafetyPageViewModel {
    var scoreType: DKScoreType = .safety
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }
    
    func getAccelerations() -> Int {
        let nbAccelCrit = Int(self.trip.safety?.nbAccelCrit ?? 0)
        let nbAccel = Int(self.trip.safety?.nbAccel ?? 0)
        return nbAccelCrit + nbAccel
    }
    
    func getBrakes() -> Int {
        let nbDecelCrit = Int(self.trip.safety?.nbDecelCrit ?? 0)
        let nbDecel = Int(self.trip.safety?.nbDecel ?? 0)
        return nbDecelCrit + nbDecel
    }
    
    func getAdherences() -> Int {
        let nbAdhCrit = Int(self.trip.safety?.nbAdhCrit ?? 0)
        let nbAdh = Int(self.trip.safety?.nbAdh ?? 0)
        return nbAdh + nbAdhCrit
    }
}
