//
//  NotificationSettingsConfigurationCell.swift
//  DriveKitApp
//
//  Created by David Bauduin on 28/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class NotificationSettingsConfigurationCell: UITableViewCell, Nibable {
    @IBOutlet private weak var channelTitle: UILabel!
    @IBOutlet private weak var channelDescription: UILabel!
    @IBOutlet private weak var channelSwitch: UISwitch!
    private var viewModel: NotificationSettingsConfigurationCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.channelTitle.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.channelTitle.textColor = DKUIColors.mainFontColor.color
        self.channelDescription.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.channelDescription.textColor = DKUIColors.complementaryFontColor.color
        self.channelSwitch.onTintColor = DKUIColors.secondaryColor.color
    }

    func updateWith(_ viewModel: NotificationSettingsConfigurationCellViewModel) {
        self.viewModel = viewModel
        self.channelTitle.text = viewModel.title
        self.channelDescription.text = viewModel.description
        self.channelSwitch.isOn = viewModel.isEnabled
    }

    @IBAction private func switchValueChanged() {
        self.viewModel?.enableChannel(self.channelSwitch.isOn)
    }
}
