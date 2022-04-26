//
//  NotificationSettings.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class NotificationSettings {
    static func enableChannel(_ channel: NotificationChannel) {
        DriveKitCoreUserDefaults.setPrimitiveType(key: channel.key, value: true)
    }

    static func disableChannel(_ channel: NotificationChannel) {
        DriveKitCoreUserDefaults.setPrimitiveType(key: channel.key, value: false)
    }

    static func isChannelEnabled(_ channel: NotificationChannel) -> Bool {
        DriveKitCoreUserDefaults.getPrimitiveType(key: channel.key) ?? true
    }
}

private extension NotificationChannel {
    var key: String {
        switch self {
            case .tripStarted:
                return "notif.tripStarted"
            case .tripCancelled:
                return "notif.tripCancelled"
            case .tripEnded:
                return "notif.tripEnded"
        }
    }
}
