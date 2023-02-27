//
//  EcoDrivingPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import CoreLocation
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import UIKit

class EcoDrivingPageViewModel {
    var scoreType: DKScoreType = .ecoDriving
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }
    
    func getAccelerations() -> String {
        let score = trip.ecoDriving?.scoreAccel ?? 0.0
        return score.getAccelerationDescription()
    }
    
    func getMaintain() -> String {
        let score = trip.ecoDriving?.scoreMain ?? 0.0
        return score.getSpeedMaintainDescription()
    }
    
    func getDecel() -> String {
        let score = trip.ecoDriving?.scoreDecel ?? 0.0
        return score.getDecelerationDescription()
    }
}
