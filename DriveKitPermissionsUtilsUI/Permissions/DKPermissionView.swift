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

    func shouldIgnore() -> Bool {
        if let key = getIgnoreUserDefauktsKey(),
           let shouldIgnore: Bool = DriveKitCoreUserDefaults.getPrimitiveType(key: key) {
            return shouldIgnore
        } else {
            return false
        }
    }

    private func getIgnoreUserDefauktsKey() -> String? {
        switch self {
            case .activity, .location:
                return nil
            case .notifications:
                return "dk_ignore_permission_notifications_key"
        }
    }

    func ignore() {
        if self == .notifications, let key = getIgnoreUserDefauktsKey() {
            DriveKitCoreUserDefaults.setPrimitiveType(key: key, value: true)
        }
    }

    var isDisplayAllowed: Bool {
        let permissionType = self.getPermissionType()
        switch permissionType {
            case .activity:
                // swiftlint:disable:next line_length
                return !DKDiagnosisHelper.shared.isActivityValid() && DKDiagnosisHelper.shared.getPermissionStatus(permissionType) != .phoneRestricted // For activity permission, allow `.phoneRestricted` status because of a system bug (if the user allows access to Motion & Fitness in global settings, on coming back to the app, the status of this permission is still "restricted" instead of something else).
            case .location:
                return !DKDiagnosisHelper.shared.isLocationValid()
            case .bluetooth:
                return false
            case .notifications:
                return DKDiagnosisHelper.shared.getPermissionStatus(.notifications) != .valid && !DKPermissionView.notifications.shouldIgnore()
            @unknown default:
                return false
        }
    }
}
