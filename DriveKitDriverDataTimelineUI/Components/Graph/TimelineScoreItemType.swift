//
//  TimelineScoreItemType.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 24/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

enum TimelineScoreItemType {
    case safety_acceleration
    case safety_braking
    case safety_adherence
    case ecoDriving_efficiencyAcceleration
    case ecoDriving_efficiencyBrake
    case ecoDriving_efficiencySpeedMaintain
    case ecoDriving_fuelVolume
    case ecoDriving_fuelSavings
    case ecoDriving_co2mass
    case distraction_unlock
    case distraction_callForbiddenDuration
    case distraction_percentageOfTripsWithForbiddenCall
    case speeding_duration
    case speeding_distance
}
