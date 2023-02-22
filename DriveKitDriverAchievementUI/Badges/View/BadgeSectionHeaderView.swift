// swiftlint:disable all
//
//  BadgeSectionHeaderView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/14/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class BadgeSectionHeaderView: UIView, Nibable {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var themeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = DKUIColors.neutralColor.color
        backgroundView.layer.cornerRadius = 4
    }
    
    func configure(theme: String) {
        themeLabel.attributedText = theme.dkAttributedString().font(dkFont: .primary, style: .headLine2).color(.mainFontColor).build()
    }
}
