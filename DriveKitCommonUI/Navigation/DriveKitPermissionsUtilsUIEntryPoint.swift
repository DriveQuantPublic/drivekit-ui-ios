//
//  DriveKitPermissionsUtilsUIEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DriveKitPermissionsUtilsUIEntryPoint {
    func getActivityPermissionViewController(_ completionHandler: () -> Void) -> UIViewController
    func getLocationPermissionViewController(_ completionHandler: () -> Void) -> UIViewController
}
