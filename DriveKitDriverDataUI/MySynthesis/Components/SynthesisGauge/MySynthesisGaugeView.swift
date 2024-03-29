// swiftlint:disable no_magic_numbers
//
//  MySynthesisGaugeView.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class MySynthesisGaugeView: UIView {
    private var viewModel: MySynthesisGaugeViewModel!
    @IBOutlet private weak var  synthesisGaugeBarView: SynthesisGaugeBarView!
    @IBOutlet private weak var  levelButton: UIButton!
    @IBOutlet private weak var  levelButtonLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  circleCursorImageView: UIImageView!
    @IBOutlet private weak var  circleCursorLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  triangleCursorImageView: UIImageView!
    @IBOutlet private weak var  triangleCursorLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  minScoreImageView: UIImageView!
    @IBOutlet private weak var  minScoreLabel: UILabel!
    @IBOutlet private weak var  minTitleLabel: UILabel!
    @IBOutlet private weak var  minScoreLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  medianScoreImageView: UIImageView!
    @IBOutlet private weak var  medianScoreLabel: UILabel!
    @IBOutlet private weak var  medianTitleLabel: UILabel!
    @IBOutlet private weak var  medianScoreLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  medianTitleLayoutConstraint: NSLayoutConstraint!

    @IBOutlet private weak var  maxScoreImageView: UIImageView!
    @IBOutlet private weak var  maxScoreLabel: UILabel!
    @IBOutlet private weak var  maxTitleLabel: UILabel!
    @IBOutlet private weak var  maxScoreLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step1Label: UILabel!
    @IBOutlet private weak var  step1LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step2Label: UILabel!
    @IBOutlet private weak var  step2LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step3Label: UILabel!
    @IBOutlet private weak var  step3LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step4Label: UILabel!
    @IBOutlet private weak var  step4LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step5Label: UILabel!
    @IBOutlet private weak var  step5LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step6Label: UILabel!
    @IBOutlet private weak var  step6LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step7Label: UILabel!
    @IBOutlet private weak var  step7LayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  step8Label: UILabel!
    @IBOutlet private weak var  step8LayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.triangleCursorImageView.image = MySynthesisConstants.triangleIcon()
        self.circleCursorImageView.image = MySynthesisConstants.filledCircleIcon(diameter: 18)
        self.minScoreImageView.image = MySynthesisConstants.circleIcon()
        self.maxScoreImageView.image = MySynthesisConstants.circleIcon()
        self.medianScoreImageView.image = MySynthesisConstants.circleIcon()
        for label in [minTitleLabel, maxTitleLabel, medianTitleLabel,
                      minScoreLabel, maxScoreLabel, medianScoreLabel,
                      step1Label, step2Label, step3Label,
                      step4Label, step5Label, step6Label,
                      step7Label, step8Label] {
            label?.textColor = DKUIColors.mainFontColor.color
        }
        minTitleLabel.text = "dk_driverdata_mysynthesis_minimum".dkDriverDataLocalized()
        maxTitleLabel.text = "dk_driverdata_mysynthesis_maximum".dkDriverDataLocalized()
        medianTitleLabel.text = "dk_driverdata_mysynthesis_median".dkDriverDataLocalized()
    }
    
    func configure(viewModel: MySynthesisGaugeViewModel) {
        self.viewModel = viewModel
        self.synthesisGaugeBarView.configure(viewModel: viewModel)
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func updateUI() {
        setupLevelsButton()
        setupCursor()
        setupLabelsPositionsAndValues()
        hideOverlappingLabels()
        adjustMedianLabelPosition()
    }
    
    private func setupLevelsButton() {
        if let viewModel, viewModel.hasScore {
            self.levelButtonLayoutConstraint.constant = viewModel.offsetForButton(
                gaugeWidth: self.synthesisGaugeBarView.bounds.size.width,
                itemWidth: self.levelButton.frame.size.width,
                margin: 5)
            self.levelButton.configure(
                title: self.viewModel.buttonTitle,
                style: .rounded(color: MySynthesisConstants.defaultColor,
                                radius: 5,
                                borderWidth: 1,
                                style: DKStyles.roundedButton.withSizeDelta(-10),
                                textColor: DKUIColors.primaryColor.color))
        } else {
            self.levelButtonLayoutConstraint.constant = self.synthesisGaugeBarView.bounds.size.width / 2
            self.levelButton.configure(
                title: "dk_driverdata_mysynthesis_can_not_be_evaluated".dkDriverDataLocalized(),
                style: .rounded(color: MySynthesisConstants.defaultColor,
                                radius: 5,
                                borderWidth: 1,
                                style: DKStyles.roundedButton.withSizeDelta(-10),
                                textColor: DKUIColors.complementaryFontColor.color))
        }
    }
    
    private func setupCursor() {
        guard let viewModel else {
            self.circleCursorImageView.isHidden = true
            self.triangleCursorImageView.isHidden = true
            return
        }
        self.circleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.triangleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        let shouldHideScore = !viewModel.hasScore
        self.circleCursorImageView.isHidden = shouldHideScore
        self.triangleCursorImageView.isHidden = shouldHideScore
    }
    
    private func setupLabelsPositionsAndValues() {
        guard let viewModel else {
            return
        }
        self.minScoreLayoutConstraint.constant = viewModel.minOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.maxScoreLayoutConstraint.constant = viewModel.maxOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.medianScoreLayoutConstraint.constant = viewModel.medianOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.step1LayoutConstraint.constant = viewModel.offsetPercent(forStep: 0) * self.synthesisGaugeBarView.bounds.size.width
        self.step2LayoutConstraint.constant = viewModel.offsetPercent(forStep: 1) * self.synthesisGaugeBarView.bounds.size.width
        self.step3LayoutConstraint.constant = viewModel.offsetPercent(forStep: 2) * self.synthesisGaugeBarView.bounds.size.width
        self.step4LayoutConstraint.constant = viewModel.offsetPercent(forStep: 3) * self.synthesisGaugeBarView.bounds.size.width
        self.step5LayoutConstraint.constant = viewModel.offsetPercent(forStep: 4) * self.synthesisGaugeBarView.bounds.size.width
        self.step6LayoutConstraint.constant = viewModel.offsetPercent(forStep: 5) * self.synthesisGaugeBarView.bounds.size.width
        self.step7LayoutConstraint.constant = viewModel.offsetPercent(forStep: 6) * self.synthesisGaugeBarView.bounds.size.width
        self.step8LayoutConstraint.constant = viewModel.offsetPercent(forStep: 7) * self.synthesisGaugeBarView.bounds.size.width
        
        self.minScoreLabel.text = self.viewModel.min.formatDouble(places: 1)
        self.maxScoreLabel.text = self.viewModel.max.formatDouble(places: 1)
        self.medianScoreLabel.text = self.viewModel.median.formatDouble(places: 1)
        self.step1Label.text = self.viewModel.scoreForStep(0).formatDouble(places: 1)
        self.step2Label.text = self.viewModel.scoreForStep(1).formatDouble(places: 1)
        self.step3Label.text = self.viewModel.scoreForStep(2).formatDouble(places: 1)
        self.step4Label.text = self.viewModel.scoreForStep(3).formatDouble(places: 1)
        self.step5Label.text = self.viewModel.scoreForStep(4).formatDouble(places: 1)
        self.step6Label.text = self.viewModel.scoreForStep(5).formatDouble(places: 1)
        self.step7Label.text = self.viewModel.scoreForStep(6).formatDouble(places: 1)
        self.step8Label.text = self.viewModel.scoreForStep(7).formatDouble(places: 1)
    }
    
    private func hideOverlappingLabels() {
        let allowedLabelsDistance: Double = 15
        self.step2Label.isHidden = self.step2LayoutConstraint.constant - self.step1LayoutConstraint.constant < allowedLabelsDistance
        self.step3Label.isHidden = !self.step2Label.isHidden && self.step3LayoutConstraint.constant - self.step2LayoutConstraint.constant < allowedLabelsDistance
        self.step4Label.isHidden = !self.step3Label.isHidden && self.step4LayoutConstraint.constant - self.step3LayoutConstraint.constant < allowedLabelsDistance
        self.step5Label.isHidden = !self.step4Label.isHidden && self.step5LayoutConstraint.constant - self.step4LayoutConstraint.constant < allowedLabelsDistance
        self.step6Label.isHidden = !self.step5Label.isHidden && self.step6LayoutConstraint.constant - self.step5LayoutConstraint.constant < allowedLabelsDistance
        self.step7Label.isHidden = !self.step6Label.isHidden && self.step7LayoutConstraint.constant - self.step6LayoutConstraint.constant < allowedLabelsDistance
        self.step8Label.isHidden = !self.step7Label.isHidden && self.step8LayoutConstraint.constant - self.step7LayoutConstraint.constant < allowedLabelsDistance
    }

    private func adjustMedianLabelPosition() {
        let allowedLabelsDistance: Double = 30
        let constraintValueWhenOverlapping: Double = -10

        if self.maxScoreLayoutConstraint.constant - self.medianScoreLayoutConstraint.constant < allowedLabelsDistance {
            self.medianTitleLayoutConstraint.constant = constraintValueWhenOverlapping
        } else {
            self.medianTitleLayoutConstraint.constant = 0
        }
    }
    
    @IBAction private func showScoresLegend() {
        guard let visibleViewController = UIApplication.shared.visibleViewController else {
            return
        }
        let viewModel = ScoreLevelLegendViewModel()
        viewModel.configure(with: self.viewModel.scoreType)
        ScoreLevelLegendViewController.createScoreLevelLegendViewController(
            configuredWith: viewModel,
            presentedBy: visibleViewController
        )
    }
}

extension MySynthesisGaugeView {
    static func createSynthesisGaugeView(embededIn containerView: UIView) -> MySynthesisGaugeView {
        guard let synthesisGaugeView = Bundle.driverDataUIBundle?.loadNibNamed(
            "MySynthesisGaugeView",
            owner: nil
        )?.first as? MySynthesisGaugeView else {
            preconditionFailure("Can't find bundle or nib for MySynthesisGaugeView")
        }
        containerView.embedSubview(synthesisGaugeView)
        return synthesisGaugeView
    }
}

class SynthesisGaugeBarView: DKRoundedBarView {
    private var viewModel: MySynthesisGaugeViewModel?

    override func draw(_ rect: CGRect) {
        let barViewItems: [DKRoundedBarViewItem] = self.viewModel?.getBarItemsToDraw() ?? []
        draw(items: barViewItems, rect: self.bounds, cornerRadius: self.bounds.size.height / 2)
    }

    func configure(viewModel: MySynthesisGaugeViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}

class SynthesisLevelButton: UIButton {
    let verticalPadding: CGFloat = 5
    let horizontalEdgePadding: CGFloat = 8
    let horizontalSpacePadding: CGFloat = 3
    let imageWidth: CGFloat = 15

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setImage(
            DKImages.info.image?
                .resizeImage(15, opaque: false).withRenderingMode(.alwaysTemplate)
                .tintedImage(withColor: DKUIColors.secondaryColor.color), for: .normal)
        self.setImage(
            DKImages.info.image?
                .resizeImage(15, opaque: false).withRenderingMode(.alwaysTemplate)
                .tintedImage(withColor: DKUIColors.secondaryColor.color), for: .highlighted)
        if #available(iOS 15.0, *) {
            self.configuration?.imagePadding = horizontalSpacePadding
            self.configuration?.imagePlacement = .trailing
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard imageView != nil else {
            return
        }
        if #unavailable(iOS 15.0) {
            imageEdgeInsets = UIEdgeInsets(
                top: verticalPadding,
                left: (bounds.width - horizontalEdgePadding - imageWidth),
                bottom: verticalPadding,
                right: horizontalEdgePadding
            )
            titleEdgeInsets = UIEdgeInsets(
                top: verticalPadding,
                left: horizontalEdgePadding - imageWidth,
                bottom: verticalPadding,
                right: horizontalEdgePadding + imageWidth + horizontalSpacePadding )
            invalidateIntrinsicContentSize()
        }

    }

    override var intrinsicContentSize: CGSize {
        if #unavailable(iOS 15.0) {
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            let desiredButtonSize = CGSize(
                width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right + imageWidth + horizontalSpacePadding,
                height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
            )
            return desiredButtonSize
        } else {
            return super.intrinsicContentSize
        }
    }
}
