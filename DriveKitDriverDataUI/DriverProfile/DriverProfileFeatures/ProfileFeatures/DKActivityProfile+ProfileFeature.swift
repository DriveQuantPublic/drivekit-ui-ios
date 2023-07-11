// swiftlint:disable no_magic_numbers
//
//  DKActivityProfile+ProfileFeature.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 30/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

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
    
    // swiftlint:disable:next cyclomatic_complexity
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
