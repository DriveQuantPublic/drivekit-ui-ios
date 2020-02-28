//
//  DKImages.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum DKImages : String {
    case ecoAccel = "dk_eco_accel",
    info = "dk_info",
    infoFilled = "dk_info_filled",
    ecoDecel = "dk_eco_decel",
    ecoDriving = "dk_ecodriving",
    ecoDrivingFilled = "dk_ecodriving_filled",
    safetyAccel = "dk_safety_accel",
    safetyDecel = "dk_safety_decel",
    safetyAdherence = "dk_safety_adherence",
    safety = "dk_safety",
    distraction = "dk_distraction",
    distractionFilled = "dk_distraction_filled"
    
    public var image : UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: self.rawValue, in: .driveKitCommonUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
    }
}
