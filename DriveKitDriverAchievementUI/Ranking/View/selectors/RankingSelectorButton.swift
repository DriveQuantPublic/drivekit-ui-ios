//
//  RankingSelectorButton.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 09/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class RankingSelectorButton: UIButton {

    private(set) var rankingSelector: RankingSelector?

    public convenience init() {
        self.init(type: .system)
        if let titleLabel = self.titleLabel {
            titleLabel.font = UIFont(name: DKUIFonts.primary.name, size: titleLabel.font.pointSize)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let half = 0.5
        self.layer.cornerRadius = self.bounds.size.height * half
    }

    func update(rankingSelector: RankingSelector) {
        self.rankingSelector = rankingSelector
        setTitle(rankingSelector.title, for: .normal)
    }

    func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = DKUIColors.secondaryColor.color
            setTitleColor(DKUIColors.fontColorOnSecondaryColor.color, for: .normal)
        } else {
            backgroundColor = DKUIColors.neutralColor.color
            setTitleColor(DKUIColors.mainFontColor.color, for: .normal)
        }
    }
    
}
