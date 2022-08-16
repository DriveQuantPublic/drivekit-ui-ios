//
//  DKDriverAchievementImages.swift
//  DriveKitDriverAchievementUI
//
//  Created by Amine Gahbiche on 18/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKDriverAchievementImages: String {
    case distraction = "dk_achievements_distraction",
         ecodriving = "dk_achievements_ecodriving",
         safety = "dk_achievements_safety",
         speeding = "dk_achievements_speeding"
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .driverAchievementUIBundle, compatibleWith: nil)
        }
    }
}
