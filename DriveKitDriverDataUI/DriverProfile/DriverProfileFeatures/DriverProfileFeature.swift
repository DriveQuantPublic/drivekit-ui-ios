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

extension DKDistanceProfile {
    var title: String {
        switch self {
        case .veryShort:
            return "dk_driverdata_profile_distance_very_short_title".dkDriverDataLocalized()
        case .short:
            return "dk_driverdata_profile_distance_short_title".dkDriverDataLocalized()
        case .medium:
            return "dk_driverdata_profile_distance_medium_title".dkDriverDataLocalized()
        case .long:
            return "dk_driverdata_profile_distance_long_title".dkDriverDataLocalized()
        case .veryLong:
            return "dk_driverdata_profile_distance_very_long_title".dkDriverDataLocalized()
        }
    }
    
    var descriptionText: String {
        switch self {
        case .veryShort:
            return "dk_driverdata_profile_distance_very_short_text".dkDriverDataLocalized()
        case .short:
            return "dk_driverdata_profile_distance_short_text".dkDriverDataLocalized()
        case .medium:
            return "dk_driverdata_profile_distance_medium_text".dkDriverDataLocalized()
        case .long:
            return "dk_driverdata_profile_distance_long_text".dkDriverDataLocalized()
        case .veryLong:
            return "dk_driverdata_profile_distance_very_long_text".dkDriverDataLocalized()
        }
    }
}

extension DKActivityProfile {
    var title: String {
        switch self {
        case .low:
            return "dk_driverdata_profile_activity_low_title".dkDriverDataLocalized()
        case .medium:
            return "dk_driverdata_profile_activity_medium_title".dkDriverDataLocalized()
        case .high:
            return "dk_driverdata_profile_activity_high_title".dkDriverDataLocalized()
        }
    }
    
    func descriptionText(forActiveWeeksPercentage activeWeeksPercentage: Int) -> String {
        guard let activeRatioValues = self.activeRatioValues(forActiveWeeksPercentage: activeWeeksPercentage) else {
            return self.descriptionTextKey(forActiveWeeksPercentage: activeWeeksPercentage).dkDriverDataLocalized()
        }
        
        return String(
            format: self.descriptionTextKey(
                forActiveWeeksPercentage: activeWeeksPercentage
            ).dkDriverDataLocalized(),
            "\(activeRatioValues.0)",
            "\(activeRatioValues.1)"
        )
    }
    
    private func descriptionTextKey(forActiveWeeksPercentage activeWeeksPercentage: Int) -> String {
        switch activeWeeksPercentage {
        case ...12:
            return "dk_driverdata_profile_activity_very_low_text"
        case 13...57:
            return "dk_driverdata_profile_activity_main_singular_text"
        case 58...89:
            return "dk_driverdata_profile_activity_main_plural_text"
        case 90...99:
            return "dk_driverdata_profile_activity_often_text"
        case 100:
            return "dk_driverdata_profile_activity_always_text"
        default:
            return ""
        }
    }
    
    private func activeRatioValues(forActiveWeeksPercentage activeWeeksPercentage: Int) -> (Int, Int)? {
        switch activeWeeksPercentage {
        case ...12:
            return nil
        case 13...18:
            return (1, 6)
        case 19...22:
            return (1, 5)
        case 23...27:
            return (1, 4)
        case 28...38:
            return (1, 3)
        case 39...57:
            return (1, 2)
        case 58...71:
            return (2, 3)
        case 72...78:
            return (3, 4)
        case 79...82:
            return (4, 5)
        case 83...89:
            return (5, 6)
        case 90...:
            return nil
        default:
            return nil
        }
    }
}

extension DKRegularityProfile {
    var title: String {
        switch self {
        case .regular:
            return "dk_driverdata_profile_regularity_regular_title".dkDriverDataLocalized()
        case .intermittent:
            return "dk_driverdata_profile_regularity_intermittent_title".dkDriverDataLocalized()
        }
    }
    
    func descriptionText(withTripCount tripCount: Int, distance: Int) -> String {
        switch self {
        case .regular:
            return String(
                format: "dk_driverdata_profile_regularity_regular_text".dkDriverDataLocalized(),
                "\(tripCount)",
                "\(distance)"
            )
        case .intermittent:
            return "dk_driverdata_profile_regularity_intermittent_text".dkDriverDataLocalized()
        }
    }
}

extension DKRoadContext {
    var title: String {
        switch self {
        case .trafficJam:
            return "dk_driverdata_profile_roadcontext_traffic_jam_title".dkDriverDataLocalized()
        case .heavyUrbanTraffic:
            return "dk_driverdata_profile_roadcontext_heavy_urban_title".dkDriverDataLocalized()
        case .city:
            return "dk_driverdata_profile_roadcontext_city_title".dkDriverDataLocalized()
        case .suburban:
            return "dk_driverdata_profile_roadcontext_suburban_title".dkDriverDataLocalized()
        case .expressways:
            return "dk_driverdata_profile_roadcontext_expressways_title".dkDriverDataLocalized()
        }
    }
    
    func descriptionText(forDistancePercentage distancePercentage: Double) -> String {
        var localizedFormatStringKey: String
        switch self {
        case .trafficJam:
            localizedFormatStringKey = "dk_driverdata_profile_roadcontext_traffic_jam_text"
        case .heavyUrbanTraffic:
            localizedFormatStringKey = "dk_driverdata_profile_roadcontext_heavy_urban_text"
        case .city:
            localizedFormatStringKey = "dk_driverdata_profile_roadcontext_city_text"
        case .suburban:
            localizedFormatStringKey = "dk_driverdata_profile_roadcontext_suburban_text"
        case .expressways:
            localizedFormatStringKey = "dk_driverdata_profile_roadcontext_expressways_text"
        }
        return String(
            format: localizedFormatStringKey.dkDriverDataLocalized(),
            "\(distancePercentage)"
        )
    }
}

extension DKMobilityProfile {
    var title: String {
        switch self {
        case .narrow:
            return "dk_driverdata_profile_mobility_narrow".dkDriverDataLocalized()
        case .small:
            return "dk_driverdata_profile_mobility_small".dkDriverDataLocalized()
        case .medium:
            return "dk_driverdata_profile_mobility_moderate".dkDriverDataLocalized()
        case .large:
            return "dk_driverdata_profile_mobility_large".dkDriverDataLocalized()
        case .wide:
            return "dk_driverdata_profile_mobility_wide".dkDriverDataLocalized()
        case .vast:
            return "dk_driverdata_profile_mobility_vast".dkDriverDataLocalized()
        }
    }
    
    func descriptionText(for percentile90th: Int?) -> String {
        guard let percentile90th else { return "" }
        return String(
            format: "dk_driverdata_profile_mobility_text".dkDriverDataLocalized(),
            "\(percentile90th)"
        )
    }

}
