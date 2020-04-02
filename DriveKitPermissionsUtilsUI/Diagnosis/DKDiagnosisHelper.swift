//
//  DKDiagnosisHelper.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

@objc public class DKDiagnosisHelper : NSObject {

    @objc public static let shared = DKDiagnosisHelper()

    @objc public func isSensorActivated(_ sensor: DKSensorType) -> Bool {
        #warning("TODO")
        return false
    }

    @objc public func getPermissionStatus(_ permissionType: DKPermissionType) -> DKPermissionStatus {
        #warning("TODO")
        return .notDetermined
    }

}
