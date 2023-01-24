// swiftlint:disable all
//
//  DKScoreType.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 17/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule

extension DKScoreType {
    public func timelineScoreSelectorImage() -> UIImage? {
        switch self {
            case .ecoDriving:
                return DKImages.ecoDrivingFlat.image
            case .safety:
                return DKImages.safetyFlat.image
            case .distraction:
                return DKImages.distractionFlat.image
            case .speeding:
                return DKImages.speedingFlat.image
        }
    }

    func hasAccess() -> Bool {
        switch self {
            case .distraction:
                return DriveKitAccess.shared.hasAccess(.phoneDistraction)
            case .ecoDriving:
                return DriveKitAccess.shared.hasAccess(.ecoDriving)
            case .safety:
                return DriveKitAccess.shared.hasAccess(.safety)
            case .speeding:
                return DriveKitAccess.shared.hasAccess(.speeding)
        }
    }
    
    var associatedScoreItemTypes: [TimelineScoreItemType] {
        switch self {
        case .safety:
            return [
                .safety_acceleration,
                .safety_braking,
                .safety_adherence
            ]
        case .ecoDriving:
            return [
                .ecoDriving_efficiencyAcceleration,
                .ecoDriving_efficiencyBrake,
                .ecoDriving_efficiencySpeedMaintain,
                .ecoDriving_fuelVolume,
                .ecoDriving_fuelSavings,
                .ecoDriving_co2mass
            ]
        case .distraction:
            return [
                .distraction_unlock,
                .distraction_callForbiddenDuration,
                .distraction_percentageOfTripsWithForbiddenCall
            ]
        case .speeding:
            return [
                .speeding_duration,
                .speeding_distance
            ]
        }
    }
}
