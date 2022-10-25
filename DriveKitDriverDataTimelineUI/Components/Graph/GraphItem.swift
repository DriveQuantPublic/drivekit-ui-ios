//
//  GraphItem.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 24/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

enum GraphItem {
    case score(DKTimelineScoreType)
    case scoreItem(TimelineScoreItemType)

    func getGraphType() -> GraphType {
        switch self {
            case .score:
                return .line
            case let .scoreItem(type):
                switch type {
                    case .distraction_forbiddenCall:
                        return .bar
                    case .distraction_numberTripWithForbiddenCall:
                        return .bar
                    case .distraction_unlock:
                        return .bar
                    case .ecoDriving_efficiency:
                        return .bar
                    case .ecoDriving_efficiencyAcceleration:
                        return .line
                    case .ecoDriving_efficiencyBrake:
                        return .line
                    case .ecoDriving_efficiencySpeedMaintain:
                        return .line
                    case .ecoDriving_fuelVolume:
                        return .bar
                    case .safety_acceleration:
                        return .bar
                    case .safety_adherence:
                        return .bar
                    case .safety_braking:
                        return .bar
                    case .speeding_distance:
                        return .bar
                    case .speeding_duration:
                        return .bar
                }
        }
    }
}
