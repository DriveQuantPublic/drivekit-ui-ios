//
//  DKRoadContext+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

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
