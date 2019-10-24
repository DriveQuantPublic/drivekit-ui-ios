//
//  ScoreType.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData

enum ScoreType: String {
    case safety, ecoDriving, distraction
    
    func isScored(trip: Trip) -> Bool {
        switch self {
        case .ecoDriving:
            return rawValue(trip: trip) <= 10 ? true : false
        case .safety:
            return rawValue(trip: trip) <= 10 ? true : false
        case .distraction:
            return rawValue(trip: trip) <= 10 ? true : false
        }
    }
    
    func rawValue(trip: Trip) -> Double {
        switch self {
        case .ecoDriving:
            return trip.ecoDriving?.score ?? 0
        case .safety:
            return  trip.safety?.safetyScore ?? 0
        case .distraction:
            return trip.driverDistraction?.score ?? 0
            
        }
    }
    
    func imageID() -> String {
        switch self {
        case .ecoDriving:
            return "dk_ecoDriving"
        case .safety:
            return "dk_safety"
        case .distraction:
            return "dk_distraction"
        }
    }
    
    func getSteps() -> [Double] {
        switch self {
        case .ecoDriving:
            let mean : Double = 7.63
            let sigma : Double = 0.844
            let steps = [mean - (2 * sigma),
                         mean - sigma,
                         mean - (0.25 * sigma),
                         mean,
                         mean + (0.25 * sigma),
                         mean + sigma,
                         mean + (2 * sigma)]
            return steps
        case .safety:
            return [0, 5.5, 6.5, 7.5, 8.5, 9.5, 10]
        case .distraction:
            return [1 ,7 ,8 , 8.5, 9 ,9.5 , 10]
        }
    }
    
    func stringValue(detailConfig: TripDetailViewConfig) -> String {
        switch self {
        case .ecoDriving:
            return detailConfig.ecoDrivingGaugeTitle
        case .safety:
            return  detailConfig.safetyGaugeTitle
        case .distraction:
            return detailConfig.distractionGaugeTitle
            
        }
    }
}
