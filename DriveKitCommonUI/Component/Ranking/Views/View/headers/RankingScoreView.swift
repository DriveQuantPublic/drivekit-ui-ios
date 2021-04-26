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
        self.userRankView.attributedText = ranking.getDriverGlobalRankAttributedText()

        if let progressionImage = ranking.getProgressionImage() {
            self.progressionView.image = progressionImage
            self.progressionView.isHidden = false
        } else {
            self.progressionView.isHidden = true
        }
    }
}
