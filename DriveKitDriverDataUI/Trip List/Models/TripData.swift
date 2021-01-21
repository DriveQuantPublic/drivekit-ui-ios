//
//  File.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

public enum TripData: String {
    case ecoDriving, safety, distraction, distance, duration
    
    func isScored(trip: Trip) -> Bool {
        switch self {
        case .ecoDriving:
            guard let score = trip.ecoDriving?.score else {
                return false
            }
            return score <= 10 ? true : false
        case .safety:
            guard let score = trip.safety?.safetyScore else {
                return false
            }
            return score <= 10 ? true : false
        case .distraction:
            guard let score = trip.driverDistraction?.score else {
                return false
            }
            return score <= 10 ? true : false
        case .distance, .duration:
            return true
        }
    }
    
    func stringValue(trip: Trip) -> String {
        switch self {
        case .ecoDriving:
            return String(format: "%.1f", trip.ecoDriving?.score ?? 0)
        case .safety:
            return String(format: "%.1f", trip.safety?.safetyScore ?? 0)
        case .distraction:
            return String(format: "%.1f", trip.driverDistraction?.score ?? 0)
        case .distance:
            return trip.tripStatistics?.distance.formatMeterDistanceInKm() ?? "0 \(DKCommonLocalizable.unitKilometer.text())"
        case .duration:
            return trip.roundedDuration.formatSecondDuration()
        }
    }
    
    
    func displayType() -> DisplayType {
        switch self {
        case .ecoDriving, .safety, .distraction:
            return .gauge
        case .duration, .distance:
            return .text
        }
    }
}

public enum DisplayType {
    case gauge, text
}
