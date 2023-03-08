// swiftlint:disable no_magic_numbers
//
//  SynthesisGaugeView.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SynthesisGaugeView: UIView {
    private var viewModel: SynthesisGaugeViewModel!
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
    @IBOutlet private weak var  meanScoreImageView: UIImageView!
    @IBOutlet private weak var  meanScoreLabel: UILabel!
    @IBOutlet private weak var  meanTitleLabel: UILabel!
    @IBOutlet private weak var  meanScoreLayoutConstraint: NSLayoutConstraint!
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
        self.triangleCursorImageView.image = SynthesisGaugeConstants.triangleIcon()
        self.circleCursorImageView.image = SynthesisGaugeConstants.filledCircleIcon(diameter: 14)
        self.minScoreImageView.image = SynthesisGaugeConstants.circleIcon()
        self.maxScoreImageView.image = SynthesisGaugeConstants.circleIcon()
        self.meanScoreImageView.image = SynthesisGaugeConstants.circleIcon()
        for label in [minTitleLabel, maxTitleLabel, meanTitleLabel,
                      minScoreLabel, maxScoreLabel, meanScoreLabel,
                      step1Label, step2Label, step3Label,
                      step4Label, step5Label, step6Label,
                      step7Label, step8Label] {
            label?.textColor = SynthesisGaugeConstants.defaultCircleColor
            levelButton.setImage(
                DKImages.info.image?
                    .resizeImage(20, opaque: false).withRenderingMode(.alwaysTemplate)
                    .tintedImage(withColor: DKUIColors.secondaryColor.color), for: .normal)

        }
        minTitleLabel.text = "dk_driverdata_mysynthesis_minimum".dkDriverDataLocalized()
        maxTitleLabel.text = "dk_driverdata_mysynthesis_maximum".dkDriverDataLocalized()
        meanTitleLabel.text = "dk_driverdata_mysynthesis_average".dkDriverDataLocalized()
    }

    func configure(viewModel: SynthesisGaugeViewModel) {
        self.viewModel = viewModel
        self.synthesisGaugeBarView.configure(viewModel: viewModel)
        updateUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    func updateUI() {
        self.circleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.triangleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.levelButtonLayoutConstraint.constant = viewModel.offsetForButton(
            gaugeWidth: self.synthesisGaugeBarView.bounds.size.width,
            itemWidth: self.levelButton.frame.size.width,
            margin: 5)
        setupLablelsPositionsAndValues()
        hideOverlappingLabels()
        self.levelButton.configure(
            text: self.viewModel.buttonTitle.dkDriverDataLocalized(),
            style: .rounded(color: SynthesisGaugeConstants.defaultCircleColor,
                            radius: 5,
                            borderWidth: 1,
                            style: DKStyles.roundedButton.withSizeDelta(-10)))
    }

    private func setupLablelsPositionsAndValues() {
        self.minScoreLayoutConstraint.constant = viewModel.minOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.maxScoreLayoutConstraint.constant = viewModel.maxOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.meanScoreLayoutConstraint.constant = viewModel.meanOffsetPercent * self.synthesisGaugeBarView.bounds.size.width
        self.step1LayoutConstraint.constant = viewModel.offsetForStep(0) * self.synthesisGaugeBarView.bounds.size.width
        self.step2LayoutConstraint.constant = viewModel.offsetForStep(1) * self.synthesisGaugeBarView.bounds.size.width
        self.step3LayoutConstraint.constant = viewModel.offsetForStep(2) * self.synthesisGaugeBarView.bounds.size.width
        self.step4LayoutConstraint.constant = viewModel.offsetForStep(3) * self.synthesisGaugeBarView.bounds.size.width
        self.step5LayoutConstraint.constant = viewModel.offsetForStep(4) * self.synthesisGaugeBarView.bounds.size.width
        self.step6LayoutConstraint.constant = viewModel.offsetForStep(5) * self.synthesisGaugeBarView.bounds.size.width
        self.step7LayoutConstraint.constant = viewModel.offsetForStep(6) * self.synthesisGaugeBarView.bounds.size.width
        self.step8LayoutConstraint.constant = viewModel.offsetForStep(7) * self.synthesisGaugeBarView.bounds.size.width

        self.minScoreLabel.text = self.viewModel.min.formatDouble(places: 1)
        self.maxScoreLabel.text = self.viewModel.max.formatDouble(places: 1)
        self.meanScoreLabel.text = self.viewModel.mean.formatDouble(places: 1)
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
}

extension SynthesisGaugeView {
    static func createSynthesisGaugeView(
        configuredWith viewModel: SynthesisGaugeViewModel,
        embededIn containerView: UIView
    ) {
        guard let synthesisGaugeView = Bundle.driverDataUIBundle?.loadNibNamed(
            "SynthesisGaugeView",
            owner: nil
        )?.first as? SynthesisGaugeView else {
            preconditionFailure("Can't find bundle or nib for SynthesisGaugeView")
        }

        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
        containerView.embedSubview(synthesisGaugeView)
        synthesisGaugeView.configure(viewModel: viewModel)
    }
}

class SynthesisGaugeBarView: DKCustomBarView {
    private var viewModel: SynthesisGaugeViewModel?

    override func draw(_ rect: CGRect) {
        let barViewItems: [DKCustomBarViewItem] = self.viewModel?.getBarItemsToDraw() ?? []
        draw(items: barViewItems, rect: self.bounds, radius: self.bounds.size.height / 2)
    }

    func configure(viewModel: SynthesisGaugeViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}

enum SynthesisGaugeConstants {
    static let defaultCircleColor = UIColor(hex: 0x036A82)
    
    static func circleIcon(diameter: CGFloat = 12, insideColor: UIColor = .white) -> UIImage? {
        let scale: CGFloat = 0
        let lineWidth: CGFloat = 4
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let path = UIBezierPath(
            arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2 - lineWidth / 2,
            startAngle: 0,
            endAngle: 2 * Double.pi,
            clockwise: true)
        path.lineWidth = lineWidth
        defaultCircleColor.setStroke()
        insideColor.setFill()
        path.stroke()
        path.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func filledCircleIcon(diameter: CGFloat = 12) -> UIImage? {
        circleIcon(diameter: diameter, insideColor: self.defaultCircleColor)
    }

    static func triangleIcon(width: CGFloat = 20) -> UIImage? {
        let scale: CGFloat = 0
        let size = CGSize(width: width, height: width)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: width))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        defaultCircleColor.setFill()
        bezierPath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
