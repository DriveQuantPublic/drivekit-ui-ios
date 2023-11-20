//
//  NotificationSettingsConfigurationCellViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 28/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

class NotificationSettingsConfigurationCellViewModel {
    weak var delegate: NotificationSettingsDelegate?
    private let channel: NotificationChannel

    init(channel: NotificationChannel) {
        self.channel = channel
    }

    var title: String {
        return self.channel.title
    }

    var description: String {
        return self.channel.getDescription(enabled: self.isEnabled)
    }

    var isEnabled: Bool {
        return NotificationSettings.isChannelEnabled(self.channel)
    }

    func enableChannel(_ enable: Bool) {
        if enable {
            NotificationSettings.enableChannel(self.channel)
        } else {
            NotificationSettings.disableChannel(self.channel)
        }
        self.delegate?.settingsDidUpdate()
    }
}
