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
}

extension GraphItem {
    var graphType: GraphType {
        get {
            switch self {
                case .score:
                    return .line
                case let .scoreItem(type):
                    switch type {
                        case .distraction_callForbiddenDuration:
                            return .bar
                        case .distraction_percentageOfTripsWithForbiddenCall:
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
                        case .ecoDriving_co2mass:
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

    var graphTitle: String {
        get {
            let key: String
            switch self {
                case let .score(type):
                    switch type {
                        case .distraction:
                            key = "dk_timeline_distraction_score"
                        case .ecoDriving:
                            key = "dk_timeline_eco_score"
                        case .safety:
                            key = "dk_timeline_safety_score"
                        case .speeding:
                            key = "dk_timeline_speeding_score"
                    }
                case let .scoreItem(type):
                    switch type {
                        case .distraction_callForbiddenDuration:
                            key = "dk_timeline_calls_duration"
                        case .distraction_percentageOfTripsWithForbiddenCall:
                            key = "dk_timeline_trips_forbidden_calls"
                        case .distraction_unlock:
                            key = "dk_timeline_nb_unlocks"
                        case .ecoDriving_efficiency:
                            key = "dk_timeline_fuel_savings"
                        case .ecoDriving_efficiencyAcceleration:
                            key = "dk_timeline_acceleration_score"
                        case .ecoDriving_efficiencyBrake:
                            key = "dk_timeline_deceleration_score"
                        case .ecoDriving_efficiencySpeedMaintain:
                            key = "dk_timeline_maintain_score"
                        case .ecoDriving_fuelVolume:
                            key = "dk_timeline_consumption"
                        case .ecoDriving_co2mass:
                            key = "dk_timeline_co2_mass"
                        case .safety_acceleration:
                            key = "dk_timeline_accelerations"
                        case .safety_adherence:
                            key = "dk_timeline_adherence"
                        case .safety_braking:
                            key = "dk_timeline_brakings"
                        case .speeding_distance:
                            key = "dk_timeline_overspeeding_distance"
                        case .speeding_duration:
                            key = "dk_timeline_overspeeding_duration"
                    }
            }
            return key.dkDriverDataTimelineLocalized()
        }
    }

    func getGraphDescription(fromValue value: Double) -> String {
        switch self {
            case .score:
                return value.formatScore()
            case let .scoreItem(type):
                switch type {
                    case .distraction_callForbiddenDuration:
                        return value.formatSecondDuration()
                    case .distraction_percentageOfTripsWithForbiddenCall:
                        return value.formatPercentage()
                    case .distraction_unlock:
                        return value.formatDouble(places: 1)
                    case .ecoDriving_efficiency:
                        return value.formatConsumption()
                    case .ecoDriving_efficiencyAcceleration:
                        return value.getAccelerationDescription()
                    case .ecoDriving_efficiencyBrake:
                        return value.getDecelerationDescription()
                    case .ecoDriving_efficiencySpeedMaintain:
                        return value.getSpeedMaintainDescription()
                    case .ecoDriving_fuelVolume:
                        return value.formatLiter()
                    case .ecoDriving_co2mass:
                        return value.formatCO2Mass()
                    case .safety_acceleration:
                        return value.formatDouble(places: 2)
                    case .safety_adherence:
                        return value.formatDouble(places: 2)
                    case .safety_braking:
                        return value.formatDouble(places: 2)
                    case .speeding_distance:
                        return value.formatPercentage()
                    case .speeding_duration:
                        return value.formatPercentage()
                }
        }
    }
}