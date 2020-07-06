//
//  RankingCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 01/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitDBAchievementAccess

class RankingCell : UICollectionReusableView {
    @IBOutlet private weak var rankImage: UIImageView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankUserBackground: UIView!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    private(set) var ranked: DKDriverRanked? = nil
    private(set) var nbRankedDrivers = 0
    private(set) var isUserRank = false

    func update(ranked: DKDriverRanked, nbRankedDrivers: Int, isUserRank: Bool) {
        self.ranked = ranked
        self.nbRankedDrivers = nbRankedDrivers
        self.isUserRank = isUserRank

        let image: UIImage?
        if ranked.rank == 1 {
            image = UIImage(named: "leaderboard_rank_first", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        } else if ranked.rank == 2 {
            image = UIImage(named: "leaderboard_rank_second", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        } else if ranked.rank == 3 {
            image = UIImage(named: "leaderboard_rank_third", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)
        } else {
            image = nil
        }
        if let image = image {
            self.rankImage.image = image
            self.rankImage.isHidden = false
            self.rankLabel.isHidden = true
        } else {
            let color: DKUIColors
            if isUserRank {
                color = .fontColorOnSecondaryColor
                self.rankUserBackground.backgroundColor = DKUIColors.secondaryColor.color
                self.rankUserBackground.isHidden = false
            } else {
                color = .mainFontColor
                self.rankUserBackground.isHidden = true
            }
            self.rankLabel.attributedText = String(ranked.rank).dkAttributedString().font(dkFont: .primary, style: .normalText).color(color).build()
            self.rankImage.isHidden = true
            self.rankLabel.isHidden = false
        }

        self.driverLabel.attributedText = (ranked.nickname ?? "-").dkAttributedString().font(dkFont: .primary, style: .headLine2).color(.mainFontColor).build()
        self.distanceLabel.attributedText = ranked.distance.formatMeterDistance().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()

        let userScoreString = String(ranked.score.formatDouble(places: 2)).dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        let numberOfUsersString = " / \(nbRankedDrivers)".dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.scoreLabel.attributedText = "%@%@".dkAttributedString().buildWithArgs(userScoreString, numberOfUsersString)
        if isUserRank {
            self.scoreLabel.backgroundColor = DKUIColors.secondaryColor.color
        } else {
            self.scoreLabel.backgroundColor = .leaderboard_grayColor
        }
    }
}
