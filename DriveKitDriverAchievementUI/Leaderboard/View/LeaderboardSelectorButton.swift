//
//  LeaderboardSelectorButton.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 09/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class LeaderboardSelectorButton : UIButton {

    private(set) var rankingSelector: RankingSelector? = nil

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2
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
