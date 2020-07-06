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

    override func update(userPosition: Int, nbRankedDrivers: Int, driverProgression: DriverProgression, rankingType: DKRankingType) {
        super.update(userPosition: userPosition, nbRankedDrivers: nbRankedDrivers, driverProgression: driverProgression, rankingType: rankingType)

        switch rankingType {
            case .distraction:
                updateRankingTypeViews(rankingTypeTitleKey: "TODO", rankingTypeImageName: "leaderboard_phone_distraction")
            case .ecoDriving:
                updateRankingTypeViews(rankingTypeTitleKey: "TODO", rankingTypeImageName: "leaderboard_ecodriving")
            case .safety:
                updateRankingTypeViews(rankingTypeTitleKey: "TODO", rankingTypeImageName: "leaderboard_safety")
        }
    }

    private func updateRankingTypeViews(rankingTypeTitleKey: String, rankingTypeImageName: String) {
        self.rankingTypeLabel.attributedText = rankingTypeTitleKey.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.rankingTypeImage.image = UIImage(named: rankingTypeImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
    }

}
