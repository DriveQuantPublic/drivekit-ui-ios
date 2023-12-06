//
//  NotificationChannel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 26/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

enum NotificationChannel {
    case tripStarted
    case tripCancelled
    case tripEnded
    case deviceConfiguration

    var isEnabled: Bool {
        return NotificationSettings.isChannelEnabled(self)
    }

    var title: String? {
        let key: String
        switch self {
            case .tripStarted:
                key = "notification_trip_in_progress_title"
            case .tripCancelled:
                key = "notification_trip_cancelled_title"
            case .tripEnded:
                key = "notification_trip_finished_title"
            case .deviceConfiguration:
                return nil
        }
        return key.keyLocalized()
    }

    func getDescription(enabled: Bool) -> String? {
        let key: String
        switch self {
            case .tripStarted:
                key = enabled ? "notification_trip_in_progress_description_enabled" : "notification_trip_in_progress_description_disabled"
            case .tripCancelled:
                key = "notification_trip_cancelled_description"
            case .tripEnded:
                key = "notification_trip_finished_description"
            case .deviceConfiguration:
                return nil
        }
        return key.keyLocalized()
    }

    var isConfigurable: Bool {
        switch self {
            case .tripStarted, .tripCancelled, .tripEnded:
                return true
            case .deviceConfiguration:
                return false
        }
    }
}
