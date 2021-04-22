//
//  RankingScoreBig.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 02/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingScoreBig: RankingScoreView {

    @IBOutlet private weak var rankingTypeImage: UIImageView!
    @IBOutlet private weak var rankingTypeLabel: UILabel!

    override func update(ranking: DKDriverRanking) {
        super.update(ranking: ranking)

        updateRankingTypeViews(ranking: ranking)
    }

    private func updateRankingTypeViews(ranking: DKDriverRanking) {
        let rankingTypeTitle = ranking.getTitle()
        self.rankingTypeLabel.attributedText = rankingTypeTitle.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        
        let rankingTypeImageName = ranking.getImage()
        // TODO: cleanup code
        self.rankingTypeImage.image = rankingTypeImageName //UIImage(named: rankingTypeImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
    }
}
