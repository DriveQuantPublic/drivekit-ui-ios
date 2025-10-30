//
//  DKMobilityProfile+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation
import DriveKitCommonUI

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
        @unknown default:
            return ""
        }
    }
    
    func descriptionText(for percentile90th: Int?) -> String {
        guard let percentile90th else { return "" }
        let useImperialUnit = DriveKitUI.shared.unitSystem == .imperial
        let key = useImperialUnit ? "dk_driverdata_profile_mobility_text_miles" : "dk_driverdata_profile_mobility_text"
        let convertedDistance = useImperialUnit ? percentile90th.convertKmToMiles() : percentile90th
        return String(
            format: key.dkDriverDataLocalized(),
            convertedDistance.formatWithThousandSeparator()
        )
    }
    
}
