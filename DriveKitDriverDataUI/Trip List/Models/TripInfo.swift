//
//  TripInfo.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

public enum TripInfo {
    case ecoDriving, safety, count
    
    func shouldDisplay(trip: Trip) -> Bool {
        guard let tripAdvices: [TripAdvice]  = trip.tripAdvices?.allObjects as? [TripAdvice] else {
            return false
        }
        switch self {
        case .ecoDriving:
            let ecoDriving = tripAdvices.filter { $0.theme == "ECODRIVING"}
            return ecoDriving.count > 0 ? true : false
        case .safety:
            let safety = tripAdvices.filter { $0.theme == "SAFETY" }
            return safety.count > 0 ? true : false
        case .count:
            return tripAdvices.count > 0 ? true : false
        }
    }
    
    func imageID() -> String? {
        switch self {
        case .ecoDriving:
            return "dk_eco_advice"
        case .safety:
            return "dk_safety_advice"
        case .count:
            return "dk_safety_advice"
        }
    }
    
    func text(trip: Trip) -> String? {
        switch self {
        case .count:
            return String(trip.tripAdvices?.count ?? 0)
        default:
            return nil
        }
    }
}
