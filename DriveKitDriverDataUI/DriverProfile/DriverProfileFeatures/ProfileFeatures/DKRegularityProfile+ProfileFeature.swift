//
//  DKRegularityProfile+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

extension DKRegularityProfile {
    var title: String {
        switch self {
        case .regular:
            return "dk_driverdata_profile_regularity_regular_title".dkDriverDataLocalized()
        case .intermittent:
            return "dk_driverdata_profile_regularity_intermittent_title".dkDriverDataLocalized()
        @unknown default:
            return ""
        }
    }
    
    func descriptionText(withTripCount tripCount: Int, distance: Int) -> String {
        switch self {
        case .regular:
            return String(
                format: "dk_driverdata_profile_regularity_regular_text".dkDriverDataLocalized(),
                tripCount.formatWithThousandSeparator(),
                distance.formatWithThousandSeparator()
            )
        case .intermittent:
            return "dk_driverdata_profile_regularity_intermittent_text".dkDriverDataLocalized()
        @unknown default:
            return ""
        }
    }
}
