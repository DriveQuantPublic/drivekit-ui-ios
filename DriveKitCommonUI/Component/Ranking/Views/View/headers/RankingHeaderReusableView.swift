//
//  RankingHeaderReusableView.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 26/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class RankingHeaderReusableView: UICollectionReusableView {

    @IBOutlet private weak var summaryContainer: UIView?
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.rankLabel.attributedText = DKCommonLocalizable.rank.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        self.driverLabel.attributedText = DKCommonLocalizable.rankingDriver.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        self.scoreLabel.attributedText = DKCommonLocalizable.rankingScore.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        self.backgroundColor = DKUIColors.backgroundView.color
    }

    func embedSummaryView(summaryView: UIView) {
        if let summaryContainer = summaryContainer {
            for subview in summaryContainer.subviews {
                subview.removeFromSuperview()
            }
            summaryContainer.embedSubview(summaryView)
        }
    }

    func updateScoreTitle(title: String) {
        self.scoreLabel.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }
}
