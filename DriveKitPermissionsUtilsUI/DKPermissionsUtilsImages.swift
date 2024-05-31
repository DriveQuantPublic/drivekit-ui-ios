//
//  DKPermissionsUtilsImages.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 21/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKPermissionsUtilsImages: String {
    case activityPermission = "dk_perm_utils_activity_permission",
         backgroundLocationPermission = "dk_perm_utils_background_location_permission",
         notificationsPermission = "dk_perm_utils_notifications_permission",
         checked = "dk_perm_utils_checked",
         highPriority = "dk_perm_utils_high_priority",
         checkedGeneric = "dk_perm_utils_checked_generic",
         highPriorityGeneric = "dk_perm_utils_high_priority_generic"
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .permissionsUtilsUIBundle, compatibleWith: nil)
        }
    }
}
