//
//  SynthesisCardView.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import UICircularProgressRing

final class SynthesisCardView: UIView, Nibable {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var explanationButton: UIButton!
    @IBOutlet private weak var circularProgressViewContainer: UIView!
    @IBOutlet private weak var cardInfoContainer: UIStackView!
    @IBOutlet private weak var bottomText: UILabel!
    @IBOutlet private weak var notCenteredConstraint: NSLayoutConstraint!
    @IBOutlet private weak var centeredConstraint: NSLayoutConstraint!

    private weak var topSynthesisCardInfo: SynthesisCardInfoView!
    private weak var middleSynthesisCardInfo: SynthesisCardInfoView!
    private weak var bottomSynthesisCardInfo: SynthesisCardInfoView!
    private weak var circularProgressView: CircularProgressView!

    var synthesisCardViewModel: SynthesisCardViewModel? {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title.textColor = DKUIColors.mainFontColor.color
        self.title.font = DKStyles.highlightSmall.withSizeDelta(-2).applyTo(font: DKUIFonts.primary)

        self.explanationButton.tintColor = DKUIColors.secondaryColor.color
        self.explanationButton.setImage(DKImages.info.image, for: .normal)

        let circularProgressView = CircularProgressView.viewFromNib
        embedProgressView(circularProgressView)
        self.circularProgressView = circularProgressView

        self.cardInfoContainer.removeAllSubviews()
        let topSynthesisCardInfo = SynthesisCardInfoView.viewFromNib
        let middleSynthesisCardInfo = SynthesisCardInfoView.viewFromNib
        let bottomSynthesisCardInfo = SynthesisCardInfoView.viewFromNib
        cardInfoContainer.addArrangedSubview(topSynthesisCardInfo)
        cardInfoContainer.addArrangedSubview(middleSynthesisCardInfo)
        cardInfoContainer.addArrangedSubview(bottomSynthesisCardInfo)
        self.topSynthesisCardInfo = topSynthesisCardInfo
        self.middleSynthesisCardInfo = middleSynthesisCardInfo
        self.bottomSynthesisCardInfo = bottomSynthesisCardInfo

        update()
    }

    private func update() {
        if self.title != nil, let tripCardViewModel = self.synthesisCardViewModel {
            self.title.text = tripCardViewModel.getTitle()
            self.explanationButton.isHidden = tripCardViewModel.getExplanationContent() == nil
            self.circularProgressView.configure(configuration: tripCardViewModel.getGaugeConfiguration())
            self.bottomText.attributedText = tripCardViewModel.getBottomText()
            self.topSynthesisCardInfo.synthesisCardInfoViewModel = tripCardViewModel.getTopSynthesisCardInfoViewModel()
            self.middleSynthesisCardInfo.synthesisCardInfoViewModel = tripCardViewModel.getMiddleSynthesisCardInfoViewModel()
            self.bottomSynthesisCardInfo.synthesisCardInfoViewModel = tripCardViewModel.getBottomSynthesisCardInfoViewModel()

            if self.topSynthesisCardInfo.synthesisCardInfoViewModel?.isEmpty() == true {
                self.topSynthesisCardInfo.isHidden = true
            } else {
                self.topSynthesisCardInfo.isHidden = false
            }
            if self.middleSynthesisCardInfo.synthesisCardInfoViewModel?.isEmpty() == true {
                self.middleSynthesisCardInfo.isHidden = true
            } else {
                self.middleSynthesisCardInfo.isHidden = false
            }
            if self.bottomSynthesisCardInfo.synthesisCardInfoViewModel?.isEmpty() == true {
                self.bottomSynthesisCardInfo.isHidden = true
            } else {
                self.bottomSynthesisCardInfo.isHidden = false
            }
            if self.synthesisCardViewModel?.shouldHideCardInfoContainer() == true {
                self.cardInfoContainer.isHidden = true
                self.centeredConstraint.isActive = true
                self.notCenteredConstraint.isActive = false
            } else {
                self.cardInfoContainer.isHidden = false
                self.centeredConstraint.isActive = false
                self.notCenteredConstraint.isActive = true
            }
        }
    }

    private func embedProgressView(_ circularProgressView: CircularProgressView) {
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        self.circularProgressViewContainer.addSubview(circularProgressView)
        let widthConstraint = circularProgressView.widthAnchor.constraint(equalTo: self.circularProgressViewContainer.widthAnchor, multiplier: 1)
        widthConstraint.priority = .defaultLow
        let heightConstraint = circularProgressView.heightAnchor.constraint(equalTo: self.circularProgressViewContainer.heightAnchor, multiplier: 1)
        heightConstraint.priority = .defaultLow
        self.circularProgressViewContainer.addConstraints([
            widthConstraint,
            heightConstraint,
            circularProgressView.widthAnchor.constraint(lessThanOrEqualTo: self.circularProgressViewContainer.widthAnchor, multiplier: 1),
            circularProgressView.heightAnchor.constraint(lessThanOrEqualTo: self.circularProgressViewContainer.heightAnchor, multiplier: 1),
            circularProgressView.widthAnchor.constraint(equalTo: circularProgressView.heightAnchor),
            circularProgressView.centerXAnchor.constraint(equalTo: self.circularProgressViewContainer.centerXAnchor),
            circularProgressView.centerYAnchor.constraint(equalTo: self.circularProgressViewContainer.centerYAnchor)
        ])
    }

    @IBAction private func showExplanation() {
        if let explanationContent = self.synthesisCardViewModel?.getExplanationContent() {
            let alert = UIAlertController(title: "", message: explanationContent, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true)
        }
    }
}
