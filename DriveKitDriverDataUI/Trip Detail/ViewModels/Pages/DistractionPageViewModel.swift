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
    let tripDetailViewModel: DKTripDetailViewModel
    let scoreType: ScoreType = .distraction

    func getScore() -> Double {
        return self.scoreType.rawValue(trip: self.trip)
    }

    func getScoreTitle() -> String {
        return self.scoreType.stringValue()
    }

    func getUnlockTitle() -> String {
        return "dk_driverdata_unlock_events".dkDriverDataLocalized()
    }

    func getUnlockDescription() -> String {
        let unlocksNumber = getUnlocksNumber()
        if unlocksNumber == 0 {
            return "dk_driverdata_no_screen_unlocking".dkDriverDataLocalized()
        } else {
            return String(format: "dk_driverdata_unlock_screen_content".dkDriverDataLocalized(), getScreenUnlockDuration(), getScreenUnlockDistance())
        }
    }

    func getUnlockValue() -> String {
        return String(getUnlocksNumber())
    }

    func getPhoneCallTitle() -> String {
        let phoneCallsNumber = getPhoneCallsNumber()
        if phoneCallsNumber == 0 {
            return "dk_driverdata_no_call_content".dkDriverDataLocalized()
        } else {
            let title: String
            if phoneCallsNumber == 1 {
                title = "dk_driverdata_phone_call_sing".dkDriverDataLocalized()
            } else {
                title = "dk_driverdata_phone_call_plur".dkDriverDataLocalized()
            }
            return String(format: title, String(phoneCallsNumber))
        }
    }

    func getPhoneCallDescription() -> String {
        let phoneCallsNumber = getPhoneCallsNumber()
        if phoneCallsNumber == 0 {
            return "dk_driverdata_no_call_congrats".dkDriverDataLocalized()
        } else {
            return String(format: "dk_driverdata_distance_travelled".dkDriverDataLocalized(), getPhoneCallsDistance())
        }
    }

    func getPhoneCallValue() -> String {
        return getPhoneCallsDuration()
    }

    func getUnlocksNumber() -> Int {
        if let nbUnlock = self.trip.driverDistraction?.nbUnlock {
            return Int(nbUnlock)
        }
        return 0
    }

    func getScreenUnlockDuration() -> String {
        return (self.trip.driverDistraction?.durationUnlock ?? 0).formatSecondDuration()
    }

    func getScreenUnlockDistance() -> String {
        return Double(self.trip.driverDistraction?.distanceUnlock ?? 0).formatMeterDistance()
    }

    func getPhoneCallsNumber() -> Int {
        return self.trip.calls?.count ?? 0
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
