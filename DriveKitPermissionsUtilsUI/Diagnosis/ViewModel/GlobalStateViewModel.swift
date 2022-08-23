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
        let title: String
        let infoKey: String

        if errorNumber == 0 {
            icon = DKPermissionsUtilsImages.checked.image
            title = "dk_perm_utils_diag_app_ok".dkPermissionsUtilsLocalized()
            infoKey = "dk_perm_utils_diag_app_ok_text"
        } else {
            icon = DKPermissionsUtilsImages.highPriority.image
            infoKey = "dk_perm_utils_app_diag_app_ko_text"
            let titleKey: String
            if errorNumber == 1 {
                titleKey = "dk_perm_utils_app_diag_app_ko_singular"
            } else {
                titleKey = "dk_perm_utils_app_diag_app_ko_plural"
            }
            title = String(format: titleKey.dkPermissionsUtilsLocalized(), errorNumber)
        }

        self.statusIcon = icon
        self.title = title
        self.info = infoKey.dkPermissionsUtilsLocalized()
    }
}
