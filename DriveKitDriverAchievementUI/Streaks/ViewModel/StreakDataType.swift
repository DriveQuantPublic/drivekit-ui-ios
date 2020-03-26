//
//  StreakDataType.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 14/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public enum StreakDataType {
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
            return "dk_achievements_streaks_acceleration_title".dkAchievementLocalized()
        case .adherence:
            return "dk_achievements_streaks_adherence_title".dkAchievementLocalized()
        case .brake:
            return "dk_achievements_streaks_brake_title".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_achievements_streaks_phone_distraction_title".dkAchievementLocalized()
        case .safety:
            return "dk_achievements_streaks_safety_title".dkAchievementLocalized()
        case .speedLimits:
            return "dk_achievements_streaks_speeding_title".dkAchievementLocalized()
        }
    }
    
    var icon : UIImage? {
        switch self {
        case .acceleration:
            return DKImages.safetyAccel.image
        case .adherence:
            return DKImages.safetyAdherence.image
        case .brake:
            return DKImages.safetyDecel.image
        case .phoneDistraction:
            return DKImages.distraction.image
        case .safety:
            return DKImages.safety.image
        case .speedLimits:
            return DKImages.ecoAccel.image
        }
    }
    
    var description : String {
        switch self {
        case .acceleration:
            return "dk_achievements_streaks_acceleration_text".dkAchievementLocalized()
        case .adherence:
            return "dk_achievements_streaks_adherence_text".dkAchievementLocalized()
        case .brake:
            return "dk_achievements_streaks_brake_text".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_achievements_streaks_phone_distraction_text".dkAchievementLocalized()
        case .safety:
            return "dk_achievements_streaks_safety_text".dkAchievementLocalized()
        case .speedLimits:
            return "dk_achievements_streaks_speeding_text".dkAchievementLocalized()
        }
    }
    
    var resetText : String {
        switch self {
        case .acceleration:
            return "dk_achievements_streaks_acceleration_reset".dkAchievementLocalized()
        case .adherence:
            return "dk_achievements_streaks_adherence_reset".dkAchievementLocalized()
        case .brake:
            return "dk_achievements_streaks_brake_reset".dkAchievementLocalized()
        case .phoneDistraction:
            return "dk_achievements_streaks_phone_distraction_reset".dkAchievementLocalized()
        case .safety:
            return "dk_achievements_streaks_safety_reset".dkAchievementLocalized()
        case .speedLimits:
            return "dk_achievements_streaks_speeding_reset".dkAchievementLocalized()
        }
    }
}
