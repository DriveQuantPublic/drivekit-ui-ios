//
//  DKDeviceConfigurationEventNotificationManager.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 16/11/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class DKDeviceConfigurationEventNotificationManager {
    static let shared: DKDeviceConfigurationEventNotificationManager = .init()
 
    private init() {}

    func getNotificationInfo() -> DKDiagnosisNotificationInfo? {
        let invalidNotifiableEvents = self.getInvalidNotifiableEvents()
        if invalidNotifiableEvents.count > 1 {
            return DKDiagnosisNotificationInfo(
                title: "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized(),
                body: "dk_perm_utils_notification_multiple_issues".dkPermissionsUtilsLocalized()
            )
        } else if let invalidType = invalidNotifiableEvents.first {
            switch invalidType {
                case .locationPermission:
                    return DKDiagnosisNotificationInfo(
                        title: "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized(),
                        body: "dk_perm_utils_notification_location_permission".dkPermissionsUtilsLocalized()
                    )
                case .bluetoothPermission:
                    return DKDiagnosisNotificationInfo(
                        title: "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized(),
                        body: "dk_perm_utils_notification_bluetooth_permission".dkPermissionsUtilsLocalized()
                    )
                case .locationSensor:
                    return DKDiagnosisNotificationInfo(
                        title: "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized(),
                        body: "dk_perm_utils_notification_location_sensor".dkPermissionsUtilsLocalized()
                    )
                case .bluetoothSensor:
                    return DKDiagnosisNotificationInfo(
                        title: "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized(),
                        body: "dk_perm_utils_notification_bluetooth_sensor".dkPermissionsUtilsLocalized()
                    )
                case .lowPowerMode, .activityPermission, .notificationPermission:
                    return nil
            }
        }
        return nil
    }

    private func getInvalidNotifiableEvents() -> [DKDeviceConfigurationEventType] {

        let diagnosisHelper = DKDiagnosisHelper.shared
        var results: [DKDeviceConfigurationEventType] = []
        if !diagnosisHelper.isActivated(.gps) {
            results.append(.locationSensor)
        }
        if !diagnosisHelper.isLocationValid() {
            results.append(.locationPermission)
        }
        if let isBluetoothRequired = DriveKit.shared.modules.tripAnalysis?.isBluetoothRequired(), isBluetoothRequired {
            if !diagnosisHelper.isBluetoothValid() {
                results.append(.bluetoothPermission)
            } else if !diagnosisHelper.isActivated(.bluetooth) {
                results.append(.bluetoothSensor)
            }
        }
        return results
    }
}

public struct DKDiagnosisNotificationInfo {
    public let title: String
    public let body: String

    public static let none: DKDiagnosisNotificationInfo = .init(title: "", body: "")
}
