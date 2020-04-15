//
//  DKPermissionView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public enum DKPermissionView : Int {
    case activity, location

    func getViewController(nextPermissionViews: [DKPermissionView], completionHandler: @escaping () -> Void) -> PermissionViewController {
        switch self {
            case .activity:
                return ActivityPermissionViewController(nibName: "ActivityPermissionViewController", nextPermissionViews: nextPermissionViews, completionHandler: completionHandler)
            case .location:
                return LocationPermissionViewController(nibName: "LocationPermissionViewController", nextPermissionViews: nextPermissionViews, completionHandler: completionHandler)
        }
    }

    func getPermissionType() -> DKPermissionType {
        switch self {
            case .activity:
                return .activity
            case .location:
                return .location
        }
    }
}
