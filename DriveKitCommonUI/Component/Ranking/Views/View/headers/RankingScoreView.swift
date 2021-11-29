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
    @IBOutlet private var infoButton: UIButton!

    weak var parentViewController: UIViewController?
    var infoPopupTitle: String?
    var infoPopupMessage: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.progressionView.tintColor = DKUIColors.mainFontColor.color
        self.infoButton.setImage(DKImages.info.image, for: .normal)
        self.infoButton.tintColor = DKUIColors.secondaryColor.color
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
        self.infoButton.isHidden = !ranking.hasInfoButton()
        self.infoPopupTitle = ranking.infoPopupTitle()
        self.infoPopupMessage = ranking.infoPopupMessage()
    }

    @IBAction func infoAction(_ sender:UIButton) {
        self.parentViewController?.showAlertMessage(title: self.infoPopupTitle, message: self.infoPopupMessage, back: false, cancel: false)        
    }
}
