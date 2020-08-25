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

    @IBOutlet private weak var userRankView: UILabel!
    @IBOutlet private weak var progressionView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.progressionView.tintColor = DKUIColors.mainFontColor.color
    }

    func update(currentDriverRank: CurrentDriverRank?, rankingType: RankingType?, nbDrivers: Int) {
        self.progressionView.image = nil

        if let currentDriverRank = currentDriverRank {
            let driverRankString = currentDriverRank.positionString.dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = currentDriverRank.rankString.dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            self.userRankView.attributedText = "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)

            if let progressionImageName = currentDriverRank.progressionImageName {
                self.progressionView.image = UIImage(named: progressionImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
                self.progressionView.isHidden = false
            } else {
                self.progressionView.isHidden = true
            }
        } else {
            self.userRankView.attributedText = "- / \(nbDrivers)".dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            self.progressionView.isHidden = true
        }
    }

}
