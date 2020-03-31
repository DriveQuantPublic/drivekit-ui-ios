//
//  DKPermissionView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum DKPermissionView {
    case activity, location

    func getViewController() -> PermissionViewController {
        switch self {
            case .activity:
                return ActivityPermissionViewController()
            case .location:
                return LocationPermissionViewController()
        }
    }
}
