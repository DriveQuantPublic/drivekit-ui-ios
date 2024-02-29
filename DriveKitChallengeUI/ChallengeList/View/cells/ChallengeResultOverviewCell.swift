// swiftlint:disable no_magic_numbers function_parameter_count
//
//  ChallengeResultOverviewCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class ChallengeResultOverviewCell: UITableViewCell, Nibable {
    @IBOutlet weak var containerView: CardView?
    @IBOutlet weak var challengeTypeTitle: UILabel?
    @IBOutlet weak var challengeValue: UILabel?
    @IBOutlet weak var medalProgressImage: UIImageView?
    @IBOutlet weak var progressBarBackgroundView: UIView?
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint?
    @IBOutlet weak var progressBarValueView: UIView?
    @IBOutlet weak var progressBarMaxLabel: UILabel?
    @IBOutlet weak var progressBarMinLabel: UILabel?
    private let goldColor = UIColor(red: 255, green: 210, blue: 50)

    var titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
    var majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 48).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color]
    var valueAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
    var indiceAttributes = [
        NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16).with(.traitBold),
        NSAttributedString.Key.foregroundColor: DKUIColors.complementaryFontColor.color
    ]

    var indiceValue: String = "/10"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureContainer()
    }

    func configureContainer() {
        clipsToBounds = false
        layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.backgroundColor = DKDefaultColors.driveKitBackgroundColor
    }

    func configureTitle(title: String) {
        let titleAttributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        self.challengeTypeTitle?.attributedText = titleAttributedString
    }

    func configureChallenge(value: String) {
        let challengeString = value + " " + self.indiceValue
        let challengeAttributedString = NSMutableAttributedString(string: challengeString, attributes: valueAttributes)
        let valueRange = (challengeString as NSString).range(of: value)
        challengeAttributedString.setAttributes(majorAttributes, range: valueRange)
        self.challengeValue?.attributedText = challengeAttributedString
    }

    func configureMedal(isNumberOne: Bool) {
        if isNumberOne {
            self.medalProgressImage?.image = DKChallengeImages.firstDriver.image?.withRenderingMode(.alwaysTemplate)
            self.medalProgressImage?.tintColor = goldColor
        } else {
            self.medalProgressImage?.image = DKChallengeImages.firstDriver.image
        }
    }

    func configureProgressBar(maxValue: Double, minValue: Double, score: Double, value: String, maxString: String, minString: String) {
        var maxValue = maxValue
        var minValue = minValue
        if score > maxValue {
            maxValue = score
        }
        if score < minValue {
            minValue = score
        }

        let minText = minString + self.indiceValue
        let maxText = maxString + self.indiceValue
        self.progressBarMaxLabel?.attributedText = NSAttributedString(string: maxText, attributes: indiceAttributes)
        self.progressBarMinLabel?.attributedText = NSAttributedString(string: minText, attributes: indiceAttributes)

        var ranking: Double = 0
        if score == minValue && score == maxValue {
            ranking = 100
            self.progressBarMinLabel?.isHidden = true
        } else {
            ranking = ((score - minValue) * 100) / (maxValue - minValue)
        }
        let progressHeight = 100 - ranking
        progressBarValueView?.backgroundColor = goldColor
        if ranking == 100 {
            configureMedal(isNumberOne: true)
        } else {
            configureMedal(isNumberOne: false)
        }
        progressBarHeight?.constant = CGFloat(progressHeight)
    }

    func configureCell(viewModel: ChallengeResultsViewModel) {
        configureTitle(title: viewModel.challengeType.scoreTitle)

        configureChallenge(value: (viewModel.driverScore.format(maximumFractionDigits: 2, minimumFractionDigits: 0)))
        configureProgressBar(maxValue: viewModel.maxScore,
                             minValue: viewModel.minScore,
                             score: viewModel.driverScore,
                             value: viewModel.driverScore.format(maximumFractionDigits: 2, minimumFractionDigits: 0),
                             maxString: viewModel.maxScore.format(maximumFractionDigits: 2, minimumFractionDigits: 0),
                             minString: viewModel.minScore.format(maximumFractionDigits: 2, minimumFractionDigits: 0))
    }
}
