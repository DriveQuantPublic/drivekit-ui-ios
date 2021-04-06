//
//  DKSynthesisCardView.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import UICircularProgressRing

final class DKSynthesisCardView: UIView, Nibable {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var explanationButton: UIButton!
    @IBOutlet private weak var circularProgressViewContainer: UIView!
    @IBOutlet private weak var cardInfoContainer: UIStackView!
    @IBOutlet private weak var bottomText: UILabel!

    var synthesisCardViewModel: SynthesisCardViewModel? = nil {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title.textColor = DKUIColors.mainFontColor.color
        self.title.font = DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold).applyTo(font: DKUIFonts.primary)

        self.explanationButton.setImage(DKImages.info.image, for: .normal)

        self.cardInfoContainer.removeAllSubviews()
        let topSynthesisCardInfo = DKSynthesisCardInfoView.viewFromNib
        let middleSynthesisCardInfo = DKSynthesisCardInfoView.viewFromNib
        let bottomSynthesisCardInfo = DKSynthesisCardInfoView.viewFromNib
        cardInfoContainer.addArrangedSubview(topSynthesisCardInfo)
        cardInfoContainer.addArrangedSubview(middleSynthesisCardInfo)
        cardInfoContainer.addArrangedSubview(bottomSynthesisCardInfo)

        update()
    }

    private func update() {
        #warning("TODO")
        if self.title != nil, let tripCardViewModel = self.synthesisCardViewModel {
            self.title.text = tripCardViewModel.getTitle()
            self.explanationButton.isHidden = tripCardViewModel.getExplanationContent() == nil
//            self.progressRing.value = CGFloat(tripCardViewModel.getGaugeConfiguration().getProgress())
            let circularProgressView = CircularProgressView.viewFromNib
            circularProgressView.configure(configuration: tripCardViewModel.getGaugeConfiguration())
            self.circularProgressViewContainer.embedSubview(circularProgressView)
            self.bottomText.attributedText = tripCardViewModel.getBottomText()
        }
    }

    @IBAction private func showExplanation() {
        #warning("TODO")
    }
}
