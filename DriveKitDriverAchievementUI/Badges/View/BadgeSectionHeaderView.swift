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
    }
    
    public func configure(theme: String) {
        themeLabel.attributedText = theme.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).build()
        self.backgroundView.backgroundColor = UIColor.red
    }
}
