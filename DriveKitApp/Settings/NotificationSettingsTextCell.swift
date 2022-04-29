//
//  NotificationSettingsConfigurationCell.swift
//  DriveKitApp
//
//  Created by David Bauduin on 28/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class NotificationSettingsTextCell: UITableViewCell, Nibable {
    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.label.textColor = DKUIColors.complementaryFontColor.color
        self.label.text = "notification_description".keyLocalized()
    }
}
