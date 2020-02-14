//
//  StreakDataType.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 14/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

enum StreakDataType {
    case phoneDistraction, safety, adherence, brake, acceleration, speedLimits
    
    static func getEnumFromStreakTheme(theme : String) -> StreakDataType {
        switch theme {
        case "PHONE_DISTRACTION":
            return .phoneDistraction
        case "SAFETY":
            return .safety
        case "SPEEDING":
            return .speedLimits
        case "ACCELERATION":
            return .acceleration
        case "BRAKE":
            return .brake
        case "ADHERENCE":
            return .adherence
        default:
            fatalError("Streak theme unknown")
        }
    }
    
    var theme : String {
        switch self {
        case .acceleration:
            return "dk_streaks_acceleration_title".dkAchievementLocalized()
        case .adherence:
            return "dk_streaks_adherence_title".dkAchievementLocalized()
        case .brake:
            return "dk_streaks_brake_title".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_streaks_phone_distraction_title".dkAchievementLocalized()
        case .safety:
            return "dk_streaks_safety_title".dkAchievementLocalized()
        case .speedLimits:
            return "dk_streaks_speeding_title".dkAchievementLocalized()
        }
    }
    
    var icon : UIImage? {
        switch self {
        case .acceleration:
            return UIImage(named: "dk_safety_accel", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        case .adherence:
            return UIImage(named: "dk_safety_adherence", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        case .brake:
            return UIImage(named: "dk_safety_decel", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        case .phoneDistraction:
            return UIImage(named: "dk_distraction", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        case .safety:
            return UIImage(named: "dk_safety", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        case .speedLimits:
            return UIImage(named: "dk_eco_accel", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        }
    }
    
    var description : String {
        switch self {
        case .acceleration:
            return "dk_streaks_acceleration_text".dkAchievementLocalized()
        case .adherence:
            return "dk_streaks_adherence_text".dkAchievementLocalized()
        case .brake:
            return "dk_streaks_brake_text".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_streaks_phone_distraction_text".dkAchievementLocalized()
        case .safety:
            return "dk_streaks_safety_text".dkAchievementLocalized()
        case .speedLimits:
            return "dk_streaks_speeding_text".dkAchievementLocalized()
        }
    }
    
    var resetText : String {
        switch self {
        case .acceleration:
            return "dk_streaks_acceleration_reset".dkAchievementLocalized()
        case .adherence:
            return "dk_streaks_adherence_reset".dkAchievementLocalized()
        case .brake:
            return "dk_streaks_brake_reset".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_streaks_phone_distraction_reset".dkAchievementLocalized()
        case .safety:
            return "dk_streaks_safety_reset".dkAchievementLocalized()
        case .speedLimits:
            return "dk_streaks_speeding_reset".dkAchievementLocalized()
        }
    }
}
