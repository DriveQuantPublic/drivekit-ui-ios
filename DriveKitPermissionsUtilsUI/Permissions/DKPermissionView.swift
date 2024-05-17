//
//  DKPermissionView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

@objc public enum DKPermissionView: Int {
    case activity, location, notifications

    func getViewController(permissionViews: [DKPermissionView], completionHandler: @escaping () -> Void) -> PermissionViewController {
        switch self {
            case .activity:
                return ActivityPermissionViewController(nibName: "ActivityPermissionViewController", permissionViews: permissionViews, completionHandler: completionHandler)
            case .location:
                return LocationPermissionViewController(nibName: "LocationPermissionViewController", permissionViews: permissionViews, completionHandler: completionHandler)
            case .notifications:
                return NotificationsPermissionViewController(
                    nibName: "NotificationsPermissionViewController",
                    permissionViews: permissionViews,
                    completionHandler: completionHandler
                )
        }
    }

    func getPermissionType() -> DKPermissionType {
        switch self {
            case .activity:
                return .activity
            case .location:
                return .location
            case .notifications:
                return .notifications
        }
    }
}
