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
        UserDefaults.standard.set(true, forKey: channel.key)
    }

    static func disableChannel(_ channel: NotificationChannel) {
        UserDefaults.standard.set(false, forKey: channel.key)
    }

    static func isChannelEnabled(_ channel: NotificationChannel) -> Bool {
        if UserDefaults.standard.object(forKey: channel.key) != nil {
            return UserDefaults.standard.bool(forKey: channel.key)
        } else {
            return true
        }
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
