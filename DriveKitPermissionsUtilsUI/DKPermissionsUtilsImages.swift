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
         backgroundLocationPermission = "dk_perm_utils_background_location_permission"
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .permissionsUtilsUIBundle, compatibleWith: nil)
        }
    }
}
