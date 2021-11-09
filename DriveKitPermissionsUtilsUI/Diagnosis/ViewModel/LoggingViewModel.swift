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

    func getLogFileUrl() -> URL? {
        if DriveKitLog.shared.isLoggingEnabled {
            return DriveKitLog.shared.getZippedLogFilesUrl()
        }
        return nil
    }
}
