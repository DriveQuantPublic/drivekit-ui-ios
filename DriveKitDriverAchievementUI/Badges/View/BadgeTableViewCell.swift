//
//  BadgeTableViewCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBAchievementAccessModule
import UICircularProgressRing

class BadgeTableViewCell: UITableViewCell {
    @IBOutlet weak var levelsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addLevelView(level: DKBadgeCharacteristics) {
        let levelView = BadgeLevelView.viewFromNib
        levelsStackView.addArrangedSubview(levelView)
        configureLevelView(levelView: levelView, level: level)
    }

    private func configureLevelView(levelView: BadgeLevelView, level: DKBadgeCharacteristics) {
        levelView.configure(level: level)
    }

    func configure(levels: [DKBadgeCharacteristics]) {
        if levelsStackView.arrangedSubviews.isEmpty {
            addLevelView(level: levels.filter{$0.level == .bronze}.first!)
            addLevelView(level: levels.filter{$0.level == .silver}.first!)
            addLevelView(level: levels.filter{$0.level == .gold}.first!)
        } else {
            configureLevelView(levelView: levelsStackView.arrangedSubviews[0] as! BadgeLevelView, level: levels.filter{$0.level == .bronze}.first!)
            configureLevelView(levelView: levelsStackView.arrangedSubviews[1] as! BadgeLevelView, level: levels.filter{$0.level == .silver}.first!)
            configureLevelView(levelView: levelsStackView.arrangedSubviews[2] as! BadgeLevelView, level: levels.filter{$0.level == .gold}.first!)
        }
    }
}
