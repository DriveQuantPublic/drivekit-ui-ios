//
//  DKPermissionStatus.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

@objc public enum DKPermissionStatus : Int {
    case valid, invalid, notDetermined, phoneRestricted
}
