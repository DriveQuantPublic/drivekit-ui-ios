//
//  RankingScoreBig.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccessModule

class RankingScoreBig : RankingScoreView {

    @IBOutlet private weak var rankingTypeImage: UIImageView!
    @IBOutlet private weak var rankingTypeLabel: UILabel!

    override func update(currentDriverRank: CurrentDriverRank?, rankingType: RankingType?, nbDrivers: Int) {
        super.update(currentDriverRank: currentDriverRank, rankingType: rankingType, nbDrivers: nbDrivers)

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
