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
    private let goldColor = UIColor(red: 255, green: 215, blue: 0)

    var titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
    var majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 48).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color]
    var valueAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
    var indiceAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.complementaryFontColor.color]

    var indiceValue: String = DKCommonLocalizable.unitKilometer.text().uppercased()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureContainer()
    }

    func configureContainer(){
        clipsToBounds = false
        layer.cornerRadius = 5
        self.backgroundColor = DKUIColors.backgroundView.color
    }

    func configureTitle(title: String){
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

    func configureMedal(isNumberOne: Bool){
        if isNumberOne {
            self.medalProgressImage?.image = UIImage(named: "best_score_gold", in: .challengeUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            self.medalProgressImage?.tintColor = goldColor
        } else {
            self.medalProgressImage?.image = UIImage(named: "best_score", in: .challengeUIBundle, compatibleWith: nil)
        }
    }

    func configureProgressBar(maxValue: Double, minValue: Double, score: Double, value: String, maxString: String, minString: String){
        var maxValue = maxValue
        var minValue = minValue
        if score > maxValue {
            maxValue = score
        }
        if score < minValue {
            minValue = score
        }

        let minText = minString + " " + self.indiceValue
        let maxText = maxString +  " " + self.indiceValue
        self.progressBarMaxLabel?.attributedText = NSAttributedString(string: maxText, attributes: indiceAttributes)
        self.progressBarMinLabel?.attributedText = NSAttributedString(string: minText, attributes: indiceAttributes)

        var ranking : Double = 0
        if score == minValue && score == maxValue {
            ranking = 100
            self.progressBarMinLabel?.isHidden = true
        } else {
            ranking = ((score - minValue) * 100) / (maxValue - minValue)
        }
        let progressHeight =  100 - ranking
        progressBarValueView?.backgroundColor = goldColor
        if ranking == 100 {
            configureMedal(isNumberOne: true)
        } else {
            configureMedal(isNumberOne: false)
        }
        progressBarHeight?.constant = CGFloat(progressHeight)
    }

    func configureCell(viewModel: ChallengeResultsViewModel) {
        if viewModel.challengeType == .score {
            configureTitle(title:  viewModel.challengeTheme.scoreTitle)
        } else {
            configureTitle(title: viewModel.challengeType.overviewTitle)
        }
        indiceValue = viewModel.challengeType.indiceType

        switch viewModel.challengeType {
        case .score:
            
            configureChallenge(value: (viewModel.driverScore.formatDouble(fractionDigits: 2)))
            configureProgressBar(maxValue: viewModel.maxScore, minValue: viewModel.minScore, score: viewModel.driverScore, value: viewModel.driverScore.formatDouble(fractionDigits: 2), maxString: viewModel.maxScore.formatDouble(fractionDigits: 2), minString: viewModel.minScore.formatDouble(fractionDigits: 2))
        case .distance:
            configureChallenge(value: viewModel.driverScore.formatDouble(fractionDigits: 2))
            configureProgressBar(maxValue: viewModel.maxScore, minValue: viewModel.minScore, score: viewModel.driverScore, value: viewModel.driverScore.stringWithoutZeroFraction, maxString: viewModel.maxScore.stringWithoutZeroFraction, minString: viewModel.minScore.stringWithoutZeroFraction)
        case .duration:
            let duration = viewModel.driverScore * 3600
            let maxDuration = viewModel.maxScore * 3600
            let minDuration = viewModel.minScore * 3600            
            configureChallenge(value: duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour))
            configureProgressBar(maxValue: maxDuration, minValue: minDuration, score: duration, value: duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour), maxString: maxDuration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour), minString: minDuration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour) )
        case .nbTrips:
            configureChallenge(value: viewModel.driverScore.stringWithoutZeroFraction)
            configureProgressBar(maxValue: viewModel.maxScore, minValue: viewModel.minScore, score: Double(viewModel.numberTrip), value: viewModel.driverScore.stringWithoutZeroFraction, maxString: viewModel.maxScore.stringWithoutZeroFraction, minString: viewModel.minScore.stringWithoutZeroFraction)
        }
    }
}
