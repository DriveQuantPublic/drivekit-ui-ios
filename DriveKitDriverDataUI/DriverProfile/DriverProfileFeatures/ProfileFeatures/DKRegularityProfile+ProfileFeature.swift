//
//  DKRegularityProfile+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation
import DriveKitCommonUI

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
            let useImperialUnit = DriveKitUI.shared.unitSystem == .imperial
            let key = useImperialUnit ? "dk_driverdata_profile_regularity_regular_text_miles" : "dk_driverdata_profile_regularity_regular_text"
            let convertedDistance = useImperialUnit ? distance.convertKmToMiles() : distance
            return String(
                format: key.dkDriverDataLocalized(),
                tripCount.formatWithThousandSeparator(),
                convertedDistance.formatWithThousandSeparator()
            )
        case .intermittent:
            return "dk_driverdata_profile_regularity_intermittent_text".dkDriverDataLocalized()
        @unknown default:
            return ""
        }
    }
}
