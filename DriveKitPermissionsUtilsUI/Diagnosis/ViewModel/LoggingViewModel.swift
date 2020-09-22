//
//  LoggingViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitCoreModule

class LoggingViewModel {
    let title: String
    private(set) var description = ""
    private(set) var isLoggingEnabled: Bool
    private(set) var isContactByMailEnabled: Bool = false

    init() {
        self.title = "dk_perm_utils_app_diag_log_title".dkPermissionsUtilsLocalized()
        self.isLoggingEnabled = DriveKitLog.shared.isLoggingEnabled
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

    func setContactByMailEnabled(_ enabled: Bool) {
        if self.isContactByMailEnabled != enabled {
            self.isContactByMailEnabled = enabled
            self.updateState()
        }
    }

    func getLogFileUrl() -> URL? {
        if self.isLoggingEnabled {
            return DriveKitLog.shared.logFile
        }
        return nil
    }

    private func updateState() {
        if self.isLoggingEnabled {
            if self.isContactByMailEnabled {
                self.description = "dk_perm_utils_app_diag_log_ok_contact_mail".dkPermissionsUtilsLocalized()
            } else {
                self.description = "dk_perm_utils_app_diag_log_ok_ios".dkPermissionsUtilsLocalized()
            }
        } else {
            self.description = "dk_perm_utils_app_diag_log_ko".dkPermissionsUtilsLocalized()
        }
    }
}
