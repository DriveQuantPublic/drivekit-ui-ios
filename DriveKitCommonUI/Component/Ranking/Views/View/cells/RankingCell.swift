// swiftlint:disable all
//
//  RankingCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 01/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class RankingCell: UICollectionViewCell {
    @IBOutlet private weak var rankImage: UIImageView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankUserBackground: UIView!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var separator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.scoreLabel.layer.cornerRadius = 5
        self.scoreLabel.clipsToBounds = true
        self.separator.backgroundColor = DKUIColors.neutralColor.color
    }

    func update(driverRank: DKDriverRankingItem) {
        let isCurrentDriver = driverRank.isCurrentUser()
        if let positionImage = driverRank.getRankImage() {
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
            self.rankLabel.attributedText = String(driverRank.getRank()).dkAttributedString().font(dkFont: .primary, style: .normalText).color(rankLabelColor).build()

            self.rankImage.isHidden = true
            self.rankLabel.isHidden = false
        }

        self.driverLabel.attributedText = (driverRank.getPseudo()).dkAttributedString().font(dkFont: .primary, style: .headLine2).color(.mainFontColor).build()
        self.distanceLabel.attributedText = driverRank.getDistance().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()

        self.scoreLabel.attributedText = driverRank.getScoreAttributedText()
        if isCurrentDriver {
            self.scoreLabel.backgroundColor = DKUIColors.secondaryColor.color
        } else {
            self.scoreLabel.backgroundColor = DKUIColors.neutralColor.color
        }
    }
}
