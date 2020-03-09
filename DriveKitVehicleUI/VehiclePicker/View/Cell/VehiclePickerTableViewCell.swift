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
        self.coloredBackgroundView.backgroundColor = DKUIColors.secondaryColor.color
        self.titleLabel.attributedText = text.dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build()
    }
    
}
