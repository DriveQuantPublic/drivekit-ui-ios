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
    @IBOutlet var challengeImageView: UIImageView!
    @IBOutlet var challengeDatesLabel: UILabel!
    @IBOutlet var challengeNameLabel: UILabel!
    @IBOutlet weak var challengeDateImage: UIImageView!
    @IBOutlet var whiteBackgroundView: UIView!
    private let grayColor = UIColor(hex:0x9e9e9e)

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

        challengeDatesLabel.textColor = grayColor
        challengeDatesLabel.font = DKUIFonts.primary.fonts(size: 14)
        challengeNameLabel.textColor = DKUIColors.mainFontColor.color
        challengeNameLabel.font = DKUIFonts.primary.fonts(size: 22).with(.traitBold)
        challengeImageView.image = UIImage(named: "Trophy", in: Bundle.challengeUIBundle, compatibleWith: nil)
        challengeDateImage.image = UIImage(named: "dk_common_calendar", in: Bundle.driveKitCommonUIBundle, compatibleWith: nil)
    }

    func configure(challenge: ChallengeItemViewModel) {
        challengeDatesLabel.attributedText = ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate)
        challengeNameLabel.text = challenge.name
        challengeImageView.image = challenge.image
    }
}
