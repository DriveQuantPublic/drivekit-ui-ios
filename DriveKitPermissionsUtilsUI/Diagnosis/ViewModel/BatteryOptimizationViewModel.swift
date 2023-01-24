// swiftlint:disable all
//
//  BatteryOptimizationViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 22/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class BatteryOptimizationViewModel {
    let title: String
    var description: String = ""
    var action: String?

    init() {
        self.title = "dk_perm_utils_app_diag_battery_title".dkPermissionsUtilsLocalized()
        update()
    }

    func update() {
        if DKDiagnosisHelper.shared.isLowPowerModeEnabled() {
            self.description = "dk_perm_utils_app_diag_battery_text_ios_enabled".dkPermissionsUtilsLocalized()
            self.action = "dk_perm_utils_app_diag_battery_link_ios".dkPermissionsUtilsLocalized()
        } else {
            self.description = "dk_perm_utils_app_diag_battery_text_ios_disabled".dkPermissionsUtilsLocalized()
            self.action = nil
        }
    }

    func performAction() {
        if self.action != nil {
            DKDiagnosisHelper.shared.openSettings()
        }
    }
}
