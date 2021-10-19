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
    private(set) var isLoggingEnabled: Bool

    init() {
        self.isLoggingEnabled = DriveKitLog.shared.isLoggingEnabled
    }

    func setLoggingEnabled(_ enabled: Bool) {
        if self.isLoggingEnabled != enabled {
            if enabled {
                DriveKit.shared.enableLogging()
            } else {
                DriveKit.shared.disableLogging()
            }
            self.isLoggingEnabled = enabled
        }
    }

    func getLogFileUrl() -> URL? {
        if self.isLoggingEnabled {
            return DriveKitLog.shared.getZippedLogFilesUrl()
        }
        return nil
    }
}
