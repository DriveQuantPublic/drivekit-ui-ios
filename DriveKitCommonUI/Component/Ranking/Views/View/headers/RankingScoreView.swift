//
//  RankingScoreView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingScoreView: UIView {

    @IBOutlet private weak var userRankView: UILabel!
    @IBOutlet private weak var progressionView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.progressionView.tintColor = DKUIColors.mainFontColor.color
    }

    func update(ranking: DKDriverRanking) {
        self.progressionView.image = nil
        // TODO: cleanup code
//        let driverRankString = currentDriverRank.positionString.dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
//        let rankString = currentDriverRank.rankString.dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
//        self.userRankView.attributedText = "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)
        self.userRankView.attributedText = ranking.getDriverGlobalRankAttributedText()

        if let progressionImage = ranking.getProgressionImage() {
            self.progressionView.image = progressionImage //UIImage(named: progressionImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
            self.progressionView.isHidden = false
        } else {
            self.progressionView.isHidden = true
        }
//    } else {
//        self.userRankView.attributedText = "- / \(nbDrivers)".dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
//        self.progressionView.isHidden = true
    }
}
