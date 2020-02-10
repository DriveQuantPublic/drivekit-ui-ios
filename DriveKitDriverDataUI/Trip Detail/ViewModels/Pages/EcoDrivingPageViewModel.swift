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

class EcoDrivingPageViewModel {
    var scoreType: ScoreType = .ecoDriving
    var trip: Trip
    var detailConfig: TripDetailViewConfig
    
    init(trip: Trip, detailConfig: TripDetailViewConfig) {
        self.trip = trip
        self.detailConfig = detailConfig
    }
    
    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }
    
    func getAccelerations() -> String {
        let score = trip.ecoDriving?.scoreAccel ?? 0
        if score < -4 {
            return detailConfig.lowAccelText
        } else if score < -2 {
            return detailConfig.weakAccelText
        }else if score < 1 {
            return detailConfig.goodAccelText
        }else if score < 3 {
            return detailConfig.strongAccelText
        }else{
           return detailConfig.highAccelText
        }
    }
    
    func getMaintain() -> String {
        let score = trip.ecoDriving?.scoreMain ?? 0
        if score < 1.5 {
            return detailConfig.goodMaintainText
        }else if score < 3.5 {
            return detailConfig.weakMaintainText
        }else {
            return detailConfig.badMaintainText
        }
    }
    
    func getDecel() -> String {
        let score = trip.ecoDriving?.scoreDecel ?? 0
        if score < -4 {
            return detailConfig.lowDecelText
        }else if score < -2 {
            return detailConfig.weakDecelText
        }else if score < 1 {
            return detailConfig.goodDecelText
        }else if score < 3 {
            return detailConfig.strongDecelText
        }else{
            return detailConfig.highDecelText
        }
    }
}
