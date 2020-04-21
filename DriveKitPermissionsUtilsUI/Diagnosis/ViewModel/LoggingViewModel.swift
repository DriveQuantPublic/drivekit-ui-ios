//
//  LoggingViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitCore

class LoggingViewModel {
    let title: String
    private(set) var description = ""
    private(set) var isLoggingEnabled: Bool

    init() {
        self.title = "dk_perm_utils_app_diag_log_title".dkPermissionsUtilsLocalized()
        self.isLoggingEnabled = true //TODO
        self.updateState()
    }

    func setLoggingEnabled(_ enabled: Bool) {
        if self.isLoggingEnabled != enabled {
            if enabled {
                DriveKit.shared.enableLogging()
            } else {
                DriveKit.shared.disableLogging()
            }
            self.isLoggingEnabled = enabled
            self.updateState()
        }
    }

    private func updateState() {
        if self.isLoggingEnabled {
            self.description = "dk_perm_utils_app_diag_log_ok".dkPermissionsUtilsLocalized()
        } else {
            self.description = "dk_perm_utils_app_diag_log_ko".dkPermissionsUtilsLocalized()
        }
    }
}
