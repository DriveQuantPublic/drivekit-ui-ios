//
//  GlobalStateViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

struct GlobalStateViewModel {
    let statusIcon: UIImage?
    let title: String
    let info: String

    init(errorNumber: Int) {
        let icon: UIImage?
        let titleKey: String
        let infoKey: String

        if errorNumber == 0 {
            icon = UIImage(named: "sensor-ok-full", in: Bundle.permissionsUtilsUIBundle, compatibleWith: nil)
            titleKey = "dk_perm_utils_diag_app_ok"
            infoKey = "dk_perm_utils_diag_app_ok_text"
        } else {
            icon = UIImage(named: "sensor-error-full", in: Bundle.permissionsUtilsUIBundle, compatibleWith: nil)
            infoKey = "dk_perm_utils_app_diag_app_ko_text"
            switch errorNumber {
                case 2:
                    titleKey = "dk_perm_utils_app_diag_app_ko_02"
                case 3:
                    titleKey = "dk_perm_utils_app_diag_app_ko_03"
                case 4:
                    titleKey = "dk_perm_utils_app_diag_app_ko_04"
                case 5:
                    titleKey = "dk_perm_utils_app_diag_app_ko_05"
                default:
                    titleKey = "dk_perm_utils_app_diag_app_ko_01"
            }
        }

        self.statusIcon = icon
        self.title = titleKey.dkPermissionsUtilsLocalized()
        self.info = infoKey.dkPermissionsUtilsLocalized()
    }
}
