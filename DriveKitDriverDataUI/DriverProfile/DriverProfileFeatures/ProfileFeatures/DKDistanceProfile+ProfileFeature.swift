//
//  DKDistanceProfile+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

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
        @unknown default:
            return ""
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
        @unknown default:
            return ""
        }
    }
}
