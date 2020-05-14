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

    @IBOutlet weak var levelsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addLevelView(level: DKBadgeLevel) {
        let levelView = BadgeLevelView.viewFromNib
        let treshold = Float(level.threshold)
        let progress = Float(level.progressValue)
        levelView.configure(level: level.level,
                            imageKey: progress >= treshold ? level.iconKey : level.defaultIconKey,
                            treshold: treshold,
                            progress: progress,
                            name: level.nameKey)
        levelsStackView.addArrangedSubview(levelView)
    }

    public func configure(theme: String, levels: [DKBadgeLevel]) {
        while levelsStackView.arrangedSubviews.count != 3 {
            for level in levels {
                if levelsStackView.arrangedSubviews.count == 0 && level.level == .bronze {
                    addLevelView(level: level)
                }
                if levelsStackView.arrangedSubviews.count == 1 && level.level == .silver {
                    addLevelView(level: level)
                }
                if levelsStackView.arrangedSubviews.count == 2 && level.level == .gold {
                    addLevelView(level: level)
                }
            }
        }
    }
}
