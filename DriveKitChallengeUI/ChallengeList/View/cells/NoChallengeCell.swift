// swiftlint:disable no_magic_numbers
//
//  NoChallengeCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class NoChallengeCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.label.layer.masksToBounds = true
        self.label.backgroundColor = DKUIColors.neutralColor.color
        self.label.font = DKStyles.normalText.style.applyTo(font: .primary)
        self.label.textColor = DKUIColors.mainFontColor.color
    }

    func configure(viewModel: NoChallengeViewModel) {
        self.label.text = viewModel.text
    }
}
