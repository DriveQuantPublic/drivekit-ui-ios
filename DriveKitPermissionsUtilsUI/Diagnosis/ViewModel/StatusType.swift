//
//  StatusType.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

enum StatusType {
    case activity, bluetooth, location, network, notification

    func getTitle() -> String {
        let titleKey: String
        switch self {
            case .activity:
                titleKey = "dk_perm_utils_app_diag_activity_title"
            case .bluetooth:
                titleKey = "dk_perm_utils_app_diag_bluetooth_title"
            case .location:
                titleKey = "dk_perm_utils_app_diag_location_title"
            case .network:
                titleKey = "dk_perm_utils_app_diag_network_title"
            case .notification:
                titleKey = "dk_perm_utils_app_diag_notification_title"
        }
        return titleKey.dkPermissionsUtilsLocalized()
    }

    func getValidDescription() -> String {
        let descriptionKey: String
        switch self {
            case .activity:
                descriptionKey = "dk_perm_utils_app_diag_activity_ok"
            case .bluetooth:
                descriptionKey = "dk_perm_utils_app_diag_bluetooth_ok"
            case .location:
                descriptionKey = "dk_perm_utils_app_diag_location_ok"
            case .network:
                descriptionKey = "dk_perm_utils_app_diag_network_ok"
            case .notification:
                descriptionKey = "dk_perm_utils_app_diag_notification_ok"
        }
        return descriptionKey.dkPermissionsUtilsLocalized()
    }

    func getInvalidDescription() -> String {
        let descriptionKey: String
        switch self {
            case .activity:
                descriptionKey = "dk_perm_utils_app_diag_activity_ko"
            case .bluetooth:
                descriptionKey = "dk_perm_utils_app_diag_bluetooth_ko"
            case .location:
                if !DKDiagnosisHelper.shared.isActivated(.gps) {
                    descriptionKey = "dk_perm_utils_app_diag_loc_sensor_ko"
                } else {
                    if DKDiagnosisHelper.shared.getLocationAccuracy() == .approximative {
                        descriptionKey = "dk_perm_utils_app_diag_location_full_ko_ios14"
                    } else if #available(iOS 13.0, *) {
                        descriptionKey = "dk_perm_utils_app_diag_location_ko_ios13"
                    } else {
                        descriptionKey = "dk_perm_utils_app_diag_location_ko_ios"
                    }
                }
            case .network:
                descriptionKey = "dk_perm_utils_app_diag_network_ko"
            case .notification:
                descriptionKey = "dk_perm_utils_app_diag_notification_ko"
        }
        return descriptionKey.dkPermissionsUtilsLocalized()
    }

    func getValidAction() -> String {
        return DKCommonLocalizable.ok.text()
    }

    func getInvalidAction() -> String {
        let actionKey: String
        switch self {
            case .activity:
                actionKey = "dk_perm_utils_app_diag_activity_link"
            case .bluetooth:
                actionKey = "dk_perm_utils_app_diag_bluetooth_link"
            case .location:
                if !DKDiagnosisHelper.shared.isActivated(.gps) {
                    actionKey = "dk_perm_utils_app_diag_loc_sensor_link"
                } else if DKDiagnosisHelper.shared.getLocationAccuracy() == .approximative {
                    actionKey = "dk_perm_utils_app_diag_location_full_link"
                } else {
                    actionKey = "dk_perm_utils_app_diag_location_link"
                }
            case .network:
                actionKey = "dk_perm_utils_app_diag_network_link"
            case .notification:
                actionKey = "dk_perm_utils_app_diag_notification_link"
        }
        return actionKey.dkPermissionsUtilsLocalized()
    }
}
