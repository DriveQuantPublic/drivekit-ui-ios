// swiftlint:disable all
//
//  NotificationSettingsViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 28/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

class NotificationSettingsViewModel {
    weak var delegate: NotificationSettingsDelegate? {
        didSet {
            self.viewModels.forEach { $0.delegate = delegate }
        }
    }
    let viewModels: [NotificationSettingsConfigurationCellViewModel] = [
        NotificationSettingsConfigurationCellViewModel(channel: .tripStarted),
        NotificationSettingsConfigurationCellViewModel(channel: .tripCancelled),
        NotificationSettingsConfigurationCellViewModel(channel: .tripEnded)
    ]
    var itemsNumber: Int {
        return self.viewModels.count
    }
}
