//
//  SensorStateViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

struct SensorStateViewModel {
    let title: String
    let statusIcon: UIImage?
    let statusIconTintColor: UIColor
    let learnMoreText: String

    init(statusType: StatusType, valid: Bool) {
        let titleKey: String
        switch statusType {
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
        self.title = titleKey.dkPermissionsUtilsLocalized()

        let icon: UIImage?
        if valid {
            icon = UIImage(named: "sensor-ok-empty", in: Bundle.permissionsUtilsUIBundle, compatibleWith: nil)
            self.statusIconTintColor = UIColor(red: 20, green: 128, blue: 20)
        } else {
            icon = UIImage(named: "sensor-error-empty", in: Bundle.permissionsUtilsUIBundle, compatibleWith: nil)
            self.statusIconTintColor = DKUIColors.criticalColor.color
        }
        self.statusIcon = icon?.withRenderingMode(.alwaysTemplate)

        self.learnMoreText = "dk_perm_utils_permissions_learn_more".dkPermissionsUtilsLocalized()
    }
}
