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

class RankingCell : UICollectionViewCell {
    @IBOutlet private weak var rankImage: UIImageView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankUserBackground: UIView!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.scoreLabel.layer.cornerRadius = 5
        self.scoreLabel.clipsToBounds = true
    }

    func update(driverRank: AnyDriverRank) {
        let isCurrentDriver = driverRank is CurrentDriverRank
        if let positionImageName = driverRank.positionImageName, let positionImage = UIImage(named: positionImageName, in: Bundle.driverAchievementUIBundle, compatibleWith: nil) {
            self.rankImage.image = positionImage
            self.rankImage.isHidden = false
            self.rankLabel.isHidden = true
            self.rankUserBackground.isHidden = true
        } else {
            let rankLabelColor: DKUIColors
            if isCurrentDriver {
                rankLabelColor = .fontColorOnSecondaryColor
                self.rankUserBackground.backgroundColor = DKUIColors.secondaryColor.color
                self.rankUserBackground.isHidden = false
            } else {
                rankLabelColor = .mainFontColor
                self.rankUserBackground.isHidden = true
            }
            self.rankLabel.attributedText = String(driverRank.positionString).dkAttributedString().font(dkFont: .primary, style: .normalText).color(rankLabelColor).build()

            self.rankImage.isHidden = true
            self.rankLabel.isHidden = false
        }

        self.driverLabel.attributedText = (driverRank.name).dkAttributedString().font(dkFont: .primary, style: .headLine2).color(.mainFontColor).build()
        self.distanceLabel.attributedText = driverRank.distanceString.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()

        let scoreLabelColor: DKUIColors
        if isCurrentDriver {
            scoreLabelColor = .fontColorOnSecondaryColor
        } else {
            scoreLabelColor = .mainFontColor
        }
        let userScoreString = driverRank.scoreString.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(scoreLabelColor).build()
        let numberOfUsersString = driverRank.totalScoreString.dkAttributedString().font(dkFont: .primary, style: .smallText).color(scoreLabelColor).build()
        self.scoreLabel.attributedText = "%@%@".dkAttributedString().buildWithArgs(userScoreString, numberOfUsersString)
        if isCurrentDriver {
            self.scoreLabel.backgroundColor = DKUIColors.secondaryColor.color
        } else {
            self.scoreLabel.backgroundColor = DKUIColors.neutralColor.color
        }
    }
}
