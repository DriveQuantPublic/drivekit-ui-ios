//
//  RankingScoreView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class RankingScoreView : UIView {

    @IBOutlet weak var userRankView: UILabel!
    @IBOutlet weak var progressionView: UIImageView!

    private(set) var currentDriverRank: CurrentDriverRank? = nil
    private(set) var rankingType: RankingType? = nil

    func update(currentDriverRank: CurrentDriverRank?, rankingType: RankingType?) {
        self.currentDriverRank = currentDriverRank
        self.rankingType = rankingType

        self.progressionView.image = nil

        if let currentDriverRank = currentDriverRank {
            let driverRankString = currentDriverRank.positionString.dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = currentDriverRank.rankString.dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            self.userRankView.attributedText = "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)

            if let progressionImageName = currentDriverRank.progressionImageName {
                self.progressionView.image = UIImage(named: progressionImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
            } else {
                self.progressionView.image = nil
            }
        } else {
            self.userRankView.attributedText = nil
        }
    }

}
