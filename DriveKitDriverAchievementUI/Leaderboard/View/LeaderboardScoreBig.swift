//
//  LeaderboardScoreBig.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class LeaderboardScoreBig : LeaderboardScoreView {

    @IBOutlet private weak var rankingTypeImage: UIImageView!
    @IBOutlet private weak var rankingTypeLabel: UILabel!

    override func update(currentDriverRank: CurrentDriverRank?, rankingType: RankingType?) {
        super.update(currentDriverRank: currentDriverRank, rankingType: rankingType)

        updateRankingTypeViews(rankingTypeTitle: rankingType?.name, rankingTypeImageName: rankingType?.imageName)
    }

    private func updateRankingTypeViews(rankingTypeTitle: String?, rankingTypeImageName: String?) {
        if let rankingTypeTitle = rankingTypeTitle {
            self.rankingTypeLabel.attributedText = rankingTypeTitle.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        } else {
            self.rankingTypeLabel.attributedText = nil
        }
        if let rankingTypeImageName = rankingTypeImageName {
            self.rankingTypeImage.image = UIImage(named: rankingTypeImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        }
    }

}
