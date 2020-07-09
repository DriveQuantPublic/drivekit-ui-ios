//
//  RankingHeaderCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 09/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class RankingHeaderCell : UICollectionReusableView {
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.rankLabel.attributedText = "dk_achievements_ranking_rank".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.driverLabel.attributedText = "dk_achievements_ranking_driver".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.scoreLabel.attributedText = "dk_achievements_ranking_score".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
}
