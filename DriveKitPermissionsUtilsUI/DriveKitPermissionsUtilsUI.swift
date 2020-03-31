//
//  DriveKitPermissionsUtilsUI.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public class DriveKitPermissionsUtilsUI {

    public static let shared = DriveKitPermissionsUtilsUI()

    public func initialize() {
        DriveKitNavigationController.shared.permissionsUtilsUI = self
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
    public func getActivityPermissionViewController(_ completionHandler: () -> Void) -> UIViewController {
        #warning("TODO: Provide right ViewController")
        return UIViewController()
    }

    public func getLocationPermissionViewController(_ completionHandler: () -> Void) -> UIViewController {
        #warning("TODO: Provide right ViewController")
        return UIViewController()
    }
}
