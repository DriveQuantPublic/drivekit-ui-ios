//
//  DriveKitPermissionsUtilsUI.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

@objc public class DriveKitPermissionsUtilsUI : NSObject {

    @objc public static let shared = DriveKitPermissionsUtilsUI()

    private override init() {
        super.init()
    }

    @objc public func initialize() {
        DriveKitNavigationController.shared.permissionsUtilsUI = self
    }

    public func showPermissionViews(_ permissionViews: [DKPermissionView], parentViewController: UIViewController, completionHandler: @escaping () -> Void) {
        // Keep only needed permission views.
        let neededPermissionViews = permissionViews.filter { (permissionView) -> Bool in
            let permissionType = permissionView.getPermissionType()
            let status = DKDiagnosisHelper.shared.getPermissionStatus(permissionType)
            return status != .valid && (permissionView != .activity || status != .phoneRestricted)
        }
        if neededPermissionViews.isEmpty {
            completionHandler()
        } else if let permissionView = neededPermissionViews.first {
            // Try to find a UINavigationController to push screens inside.
            var navigationController: UINavigationController? = nil
            if let parentNavigationController = parentViewController as? UINavigationController {
                navigationController = parentNavigationController
            } else if let parentNavigationController = parentViewController.navigationController {
                navigationController = parentNavigationController
            }
            let permissionViewController = permissionView.getViewController(permissionViews: neededPermissionViews, completionHandler: completionHandler)
            if let navigationController = navigationController {
                // A UINavigationController has been found, push screen inside.
                permissionViewController.isPresentedByModule = false
                navigationController.pushViewController(permissionViewController, animated: true)
            } else if neededPermissionViews.count == 1 {
                // No UINavigationController found and just only one screen to show -> Present it.
                permissionViewController.isPresentedByModule = true
                parentViewController.present(permissionViewController, animated: true, completion: nil)
            } else {
                // No UINavigationController found and several screens to show -> Create a UINavigationController to push them inside and present this navigation controller.
                permissionViewController.isPresentedByModule = true
                let navigationController = UINavigationController(rootViewController: permissionViewController)
                parentViewController.present(navigationController, animated: true, completion: nil)
            }
        }
    }

}

extension Bundle {
    static let permissionsUtilsUIBundle = Bundle(identifier: "com.drivequant.drivekit-permissions-utils-ui")
}

extension String {
    public func dkPermissionsUtilsLocalized() -> String {
        return self.dkLocalized(tableName: "PermissionsUtilsLocalizables", bundle: Bundle.permissionsUtilsUIBundle ?? .main)
    }
}

extension DriveKitPermissionsUtilsUI : DriveKitPermissionsUtilsUIEntryPoint {
    public func getActivityPermissionViewController(_ completionHandler: @escaping () -> Void) -> UIViewController {
        return DKPermissionView.activity.getViewController(permissionViews: [.activity], completionHandler: completionHandler)
    }

    public func getLocationPermissionViewController(_ completionHandler: @escaping () -> Void) -> UIViewController {
        return DKPermissionView.location.getViewController(permissionViews: [.location], completionHandler: completionHandler)
    }
}


extension DriveKitPermissionsUtilsUI {

    @objc(showPermissionViews:parentViewController:completionHandler:) // Usage example: [DriveKitPermissionsUtilsUI.shared showPermissionViews:@[ @(DKPermissionViewLocation), @(DKPermissionViewActivity) ] parentViewController: ... completionHandler: ...];
    public func objc_showPermissionViews(_ permissionViews: [Int], parentViewController: UIViewController, completionHandler: @escaping () -> Void) {
        showPermissionViews(permissionViews.map({ DKPermissionView(rawValue: $0)! }), parentViewController: parentViewController, completionHandler: completionHandler)
    }

}
