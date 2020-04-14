//
//  VehiclePickerTableViewCell.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coloredBackgroundView: UIView!

    func configure(text: String) {
        self.coloredBackgroundView.layer.cornerRadius = 2
        self.coloredBackgroundView.layer.shadowColor = UIColor.black.cgColor
        self.coloredBackgroundView.layer.shadowOpacity = 0.3
        self.coloredBackgroundView.layer.shadowRadius = 4
        self.coloredBackgroundView.layer.shadowOffset = .zero
        self.coloredBackgroundView.backgroundColor = DKUIColors.secondaryColor.color
        self.titleLabel.attributedText = text.dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 17, traits: .traitBold)).color(.fontColorOnSecondaryColor).build()
    }
}
