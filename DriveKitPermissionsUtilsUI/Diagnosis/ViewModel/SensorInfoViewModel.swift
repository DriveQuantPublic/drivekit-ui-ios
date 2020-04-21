//
//  SensorInfoViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SensorInfoViewModel {
    let title: String
    let description: String
    let buttonTitle: String
    private let statusType: StatusType
    private let isValid: Bool
    private weak var diagnosisViewModel: DiagnosisViewModel?

    init(statusType: StatusType, isValid: Bool, diagnosisViewModel: DiagnosisViewModel) {
        self.statusType = statusType
        self.isValid = isValid
        self.diagnosisViewModel = diagnosisViewModel
        self.title = SensorInfoViewModel.getTitle(statusType: statusType)
        let (description, buttonTitle) = SensorInfoViewModel.getDescriptionAndButtonTitle(statusType: statusType, isValid: isValid)
        self.description = description
        self.buttonTitle = buttonTitle
    }

    func manageAction() {
        if let diagnosisViewModel = self.diagnosisViewModel {
            diagnosisViewModel.performDialogAction(for: self.statusType, isValid: self.isValid)
        }
    }

    private static func getTitle(statusType: StatusType) -> String {
        let title: String
        switch statusType {
            case .activity:
                title = "dk_perm_utils_app_diag_activity_title".dkPermissionsUtilsLocalized()
            case .bluetooth:
                title = "dk_perm_utils_app_diag_bluetooth_title".dkPermissionsUtilsLocalized()
            case .location:
                title = "dk_perm_utils_app_diag_loc_sensor_title".dkPermissionsUtilsLocalized()
            case .network:
                title = "dk_perm_utils_app_diag_network_title".dkPermissionsUtilsLocalized()
            case .notification:
                title = "dk_perm_utils_app_diag_notification_title".dkPermissionsUtilsLocalized()
        }
        return title
    }

    private static func getDescriptionAndButtonTitle(statusType: StatusType, isValid: Bool) -> (String, String) {
        switch statusType {
            case .activity:
                return getDescriptionAndButtonTitleForActivity(isValid: isValid)
            case .bluetooth:
                return getDescriptionAndButtonTitleForBluetooth(isValid: isValid)
            case .location:
                return getDescriptionAndButtonTitleForLocation(isValid: isValid)
            case .network:
                return getDescriptionAndButtonTitleForNetwork(isValid: isValid)
            case .notification:
                return getDescriptionAndButtonTitleForNotification(isValid: isValid)
        }
    }

    private static func getDescriptionAndButtonTitleForActivity(isValid: Bool) -> (String, String) {
        let description: String
        let buttonTitle: String
        if isValid {
            description = "dk_perm_utils_app_diag_activity_ok".dkPermissionsUtilsLocalized()
            buttonTitle = DKCommonLocalizable.ok.text()
        } else {
            description = "dk_perm_utils_app_diag_activity_ko".dkPermissionsUtilsLocalized()
            buttonTitle = "dk_perm_utils_app_diag_activity_link".dkPermissionsUtilsLocalized()
        }
        return (description, buttonTitle)
    }

    private static func getDescriptionAndButtonTitleForBluetooth(isValid: Bool) -> (String, String) {
        let description: String
        let buttonTitle: String
        if isValid {
            description = "dk_perm_utils_app_diag_bluetooth_ok".dkPermissionsUtilsLocalized()
            buttonTitle = DKCommonLocalizable.ok.text()
        } else {
            description = "dk_perm_utils_app_diag_bluetooth_ko".dkPermissionsUtilsLocalized()
            buttonTitle = "dk_perm_utils_app_diag_bluetooth_link".dkPermissionsUtilsLocalized()
        }
        return (description, buttonTitle)
    }

    private static func getDescriptionAndButtonTitleForLocation(isValid: Bool) -> (String, String) {
        let description: String
        let buttonTitle: String
        if isValid {
            description = "dk_perm_utils_app_diag_location_ok".dkPermissionsUtilsLocalized()
            buttonTitle = DKCommonLocalizable.ok.text()
        } else if !DKDiagnosisHelper.shared.isSensorActivated(.gps) {
            description = "dk_perm_utils_app_diag_loc_sensor_ko".dkPermissionsUtilsLocalized()
            buttonTitle = "dk_perm_utils_app_diag_loc_sensor_link".dkPermissionsUtilsLocalized()
        } else  {
            if #available(iOS 13.0, *) {
                description = "dk_perm_utils_app_diag_location_ko_ios13".dkPermissionsUtilsLocalized()
            } else {
                description = "dk_perm_utils_app_diag_location_ko_ios".dkPermissionsUtilsLocalized()
            }
            buttonTitle = "dk_perm_utils_app_diag_location_link".dkPermissionsUtilsLocalized()
        }
        return (description, buttonTitle)
    }

    private static func getDescriptionAndButtonTitleForNetwork(isValid: Bool) -> (String, String) {
        let description: String
        let buttonTitle: String
        if isValid {
            description = "dk_perm_utils_app_diag_network_ok".dkPermissionsUtilsLocalized()
            buttonTitle = DKCommonLocalizable.ok.text()
        } else {
            description = "dk_perm_utils_app_diag_network_ko".dkPermissionsUtilsLocalized()
            buttonTitle = "dk_perm_utils_app_diag_network_link".dkPermissionsUtilsLocalized()
        }
        return (description, buttonTitle)
    }

    private static func getDescriptionAndButtonTitleForNotification(isValid: Bool) -> (String, String) {
        let description: String
        let buttonTitle: String
        if isValid {
            description = "dk_perm_utils_app_diag_notification_ok".dkPermissionsUtilsLocalized()
            buttonTitle = DKCommonLocalizable.ok.text()
        } else {
            description = "dk_perm_utils_app_diag_notification_ko".dkPermissionsUtilsLocalized()
            buttonTitle = "dk_perm_utils_app_diag_notification_link".dkPermissionsUtilsLocalized()
        }
        return (description, buttonTitle)
    }
}
