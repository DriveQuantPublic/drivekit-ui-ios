//
//  DriverProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

enum DriverProfileFeature: CaseIterable {
    case distance, activity, regularity, mainRoadContext, mobility
}

extension DriverProfileFeature {
    func title(for driverProfile: DKDriverProfile) -> String {
        switch self {
        case .distance:
            return driverProfile.distance.title
        case .activity:
            return driverProfile.activity.title
        case .regularity:
            return driverProfile.regularity.title
        case .mainRoadContext:
            return driverProfile.mainRoadContext.title
        case .mobility:
            return driverProfile.mobility.title
        }
    }
    
    func descriptionText(for driverProfile: DKDriverProfile) -> String {
        switch self {
        case .distance:
            return driverProfile.distance.descriptionText
        case .activity:
            return driverProfile.activity.descriptionText(forActiveWeeksPercentage: driverProfile.statistics.activeWeekPercentage)
        case .regularity:
            return driverProfile.regularity.descriptionText(
                withTripCount: driverProfile.statistics.tripsNumber,
                distance: driverProfile.statistics.totalDistance
            )
        case .mainRoadContext:
            return driverProfile.mainRoadContext.descriptionText(
                forDistancePercentage: driverProfile
                    .roadContextInfoByRoadContext[driverProfile.mainRoadContext]?
                    .distancePercentage ?? 0.0
            )
        case .mobility:
            return driverProfile.mobility.descriptionText(for: driverProfile.mobilityAreaRadiusByType[.percentile90Th])
        }
    }
    
    var iconName: String {
        switch self {
        case .distance:
            return "dk_profile_distance".dkDriverDataLocalized()
        case .activity:
            return "dk_profile_activity".dkDriverDataLocalized()
        case .regularity:
            return "dk_profile_regularity".dkDriverDataLocalized()
        case .mainRoadContext:
            return "dk_profile_context".dkDriverDataLocalized()
        case .mobility:
            return "dk_profile_mobility".dkDriverDataLocalized()
        }
    }
}
