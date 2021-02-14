//
//  DistractionPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import CoreLocation
import DriveKitCommonUI

struct DistractionPageViewModel {
    let trip: Trip
    let scoreType: ScoreType = .distraction

    func getScore() -> Double {
        return self.scoreType.rawValue(trip: self.trip)
    }

    func getScoreTitle() -> String {
        return self.scoreType.stringValue()
    }

    func getUnlocksNumber() -> String {
        return String(self.trip.driverDistraction?.nbUnlock ?? 0)
    }

    func getScreenUnlockDuration() -> String {
        return (self.trip.driverDistraction?.durationUnlock ?? 0).formatSecondDuration()
    }

    func getScreenUnlockDistance() -> String {
        return Double(self.trip.driverDistraction?.distanceUnlock ?? 0).formatMeterDistance()
    }

    func getPhoneCallsNumber() -> String {
        return String(self.trip.calls?.count ?? 0)
    }

    func getPhoneCallsDuration() -> String {
        if let calls = self.trip.calls as? Set<Call> {
            let duration = calls.reduce(into: 0) { result, call in
                result += call.duration
            }
            return Double(duration).formatSecondDuration()
        }
        return 0.formatSecondDuration()
    }

    func getPhoneCallsDistance() -> String {
        if let calls = self.trip.calls as? Set<Call> {
            let duration = calls.reduce(into: 0) { result, call in
                result += call.distance
            }
            return Double(duration).formatMeterDistance()
        }
        return 0.formatMeterDistance()
    }
}
