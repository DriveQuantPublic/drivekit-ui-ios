// swiftlint:disable no_magic_numbers
//
//  ChallengeStatCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class ChallengeStatCell: UITableViewCell, Nibable {
    @IBOutlet weak var statsLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var containerView: CardView?

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.backgroundColor = DKDefaultColors.driveKitBackgroundColor
    }
    
    func configure(viewModel: ChallengeResultsViewModel, type: ChallengeStatType) {
        self.statsLabel?.attributedText = viewModel.getStatAttributedString(challengeStatType: type)
        self.descriptionLabel?.attributedText = viewModel.getStatDescriptionAttributedString(challengeStatType: type)
    }
}
