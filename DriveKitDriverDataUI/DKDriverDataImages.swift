//
//  DKDriverDataImages.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 13/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKDriverDataImages: String {
    case mapAccel = "dk_map_accel",
         mapAccelHigh = "dk_map_accel_high",
         mapDecel = "dk_map_decel",
         mapDecelHigh = "dk_map_decel_high",
         mapAdh = "dk_map_adh",
         mapAdhHigh = "dk_map_adh_high",
         mapLock = "dk_map_lock",
         mapUnlock = "dk_map_unlock",
         mapBeginCall = "dk_map_begin_call",
         mapEndCall = "dk_map_end_call",
         lockEvent = "dk_lock_event",
         unlockEvent = "dk_unlock_event",
         beginCall = "dk_begin_call",
         endCall = "dk_end_call"
    
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: self.rawValue, in: .driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
    }
}
