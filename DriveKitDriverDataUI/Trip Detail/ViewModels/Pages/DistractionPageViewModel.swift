// swiftlint:disable all
//
//  DistractionPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import CoreLocation
import DriveKitCommonUI

struct DistractionPageViewModel {
    let trip: Trip
    let tripDetailViewModel: DKTripDetailViewModel
    let scoreType: DKScoreType = .distraction

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
        if getScreenUnlockDurationValue() == 0 && getScreenUnlockDistanceValue() == 0 {
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

    func getScreenUnlockDurationValue() -> Double {
        return self.trip.driverDistraction?.durationUnlock ?? 0
    }

    func getScreenUnlockDuration() -> String {
        return formatDuration(getScreenUnlockDurationValue())
    }

    func getScreenUnlockDistanceValue() -> Double {
        return self.trip.driverDistraction?.distanceUnlock ?? 0
    }

    func getScreenUnlockDistance() -> String {
        return formatDistance(getScreenUnlockDistanceValue())
    }

    func getPhoneCallsNumber() -> Int {
        return self.trip.calls?.count ?? 0
    }

    func getPhoneCallsDuration() -> String {
        if let calls = self.trip.calls as? Set<Call> {
            let duration = calls.reduce(into: 0) { result, call in
                result += call.duration
            }
            return formatDuration(Double(duration))
        }
        return formatDuration(0)
    }

    func getPhoneCallsDistance() -> String {
        if let calls = self.trip.calls as? Set<Call> {
            let distance = calls.reduce(into: 0) { result, call in
                result += call.distance
            }
            return formatDistance(Double(distance))
        }
        return formatDistance(0)
    }

    private func formatDuration(_ duration: Double) -> String {
        return duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration()
    }

    private func formatDistance(_ distance: Double) -> String {
        return distance.ceilMeterDistance(ifGreaterThan: 10_000).formatMeterDistance()
    }
}
