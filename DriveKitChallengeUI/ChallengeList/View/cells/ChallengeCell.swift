// swiftlint:disable all
//
//  ChallengeCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeCell: UICollectionViewCell {
    @IBOutlet private var challengeImageView: UIImageView!
    @IBOutlet private var challengeDatesLabel: UILabel!
    @IBOutlet private var challengeNameLabel: UILabel!
    @IBOutlet private weak var challengeDateImage: UIImageView!
    @IBOutlet private var whiteBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        self.whiteBackgroundView?.layer.cornerRadius = 2.0
        self.whiteBackgroundView?.layer.masksToBounds = false
        self.whiteBackgroundView?.layer.shadowOpacity = 0.5
        self.whiteBackgroundView?.layer.shadowColor = UIColor.black.cgColor
        self.whiteBackgroundView?.layer.shadowOffset = CGSize(width: 1, height: 1)

        challengeDatesLabel.textColor = DKUIColors.complementaryFontColor.color
        challengeDatesLabel.font = DKUIFonts.primary.fonts(size: 14)
        challengeNameLabel.textColor = DKUIColors.mainFontColor.color
        challengeNameLabel.font = DKUIFonts.primary.fonts(size: 22).with(.traitBold)
        challengeImageView.image = UIImage(named: "101", in: Bundle.challengeUIBundle, compatibleWith: nil)
        challengeDateImage.image = DKImages.calendar.image
        challengeDateImage.tintColor = DKUIColors.mainFontColor.color
    }

    func configure(challenge: ChallengeItemViewModel) {
        challengeDatesLabel.attributedText = ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate, tintColor: DKUIColors.complementaryFontColor.color)
        challengeNameLabel.text = challenge.name
        challengeImageView.image = challenge.image
    }
}
