//
//  BadgeTableViewCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBAchievementAccess
import UICircularProgressRing

class BadgeTableViewCell : UITableViewCell {

    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var levelsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(theme: String, levels: [DKBadgeLevel]) {
        self.themeLabel.text = theme
        for level in levels {
            let levelView = BadgeLevelView()
            levelView.configure(level: level.level,
                                imageKey: level.iconKey,
                                treshold: Float(level.threshold),
                                progress: Float(level.progressValue),
                                name: level.nameKey)
            levelsStackView.addArrangedSubview(levelView)
        }
    }
}
