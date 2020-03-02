//
//  EcoDrivingPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess
import CoreLocation
import DriveKitCommonUI

class EcoDrivingPageViewModel {
    var scoreType: ScoreType = .ecoDriving
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }
    
    func getAccelerations() -> String {
        let score = trip.ecoDriving?.scoreAccel ?? 0
        if score < -4 {
            return "dk_low_accel".dkDriverDataLocalized()
        } else if score < -2 {
            return "dk_weak_accel".dkDriverDataLocalized()
        }else if score < 1 {
            return "dk_good_accel".dkDriverDataLocalized()
        }else if score < 3 {
            return "dk_strong_accel".dkDriverDataLocalized()
        }else{
           return "dk_high_accel".dkDriverDataLocalized()
        }
    }
    
    func getMaintain() -> String {
        let score = trip.ecoDriving?.scoreMain ?? 0
        if score < 1.5 {
            return "dk_good_maintain".dkDriverDataLocalized()
        }else if score < 3.5 {
            return "dk_weak_maintain".dkDriverDataLocalized()
        }else {
            return "dk_bad_maintain".dkDriverDataLocalized()
        }
    }
    
    func getDecel() -> String {
        let score = trip.ecoDriving?.scoreDecel ?? 0
        if score < -4 {
            return "dk_low_decel".dkDriverDataLocalized()
        }else if score < -2 {
            return "dk_weak_decel".dkDriverDataLocalized()
        }else if score < 1 {
            return "dk_good_decel".dkDriverDataLocalized()
        }else if score < 3 {
            return "dk_strong_decel".dkDriverDataLocalized()
        }else{
            return "dk_high_decel".dkDriverDataLocalized()
        }
    }
}
