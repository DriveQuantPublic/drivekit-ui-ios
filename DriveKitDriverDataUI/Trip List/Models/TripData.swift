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

extension TripData {
    func isScored(trip: Trip) -> Bool {
        switch self {
        case .safety, .ecoDriving:
            return !trip.unscored
        case .distraction:
            if !trip.unscored, let score = trip.driverDistraction?.score {
                return score <= 10
            }
            return false
        case .speeding:
            if !trip.unscored, let score = trip.speedingStatistics?.score {
                return score <= 10
            }
            return false
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
        case .speeding:
            return String(format: "%.1f", trip.speedingStatistics?.score ?? 0)
        case .distance:
            return trip.tripStatistics?.distance.formatMeterDistanceInKm() ?? "0 \(DKCommonLocalizable.unitKilometer.text())"
        case .duration:
            return trip.duration.roundUp(step: 60.0).formatSecondDuration()
        }
    }
}
