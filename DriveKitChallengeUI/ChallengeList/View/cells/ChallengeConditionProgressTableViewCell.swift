// swiftlint:disable no_magic_numbers
//
//  ChallengeConditionProgressTableViewCell.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 25/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class ChallengeConditionProgressTableViewCell: UITableViewCell, Nibable {
    @IBOutlet private var label: UILabel?
    @IBOutlet private var progressView: UIProgressView?

    var viewModel: ChallengeConditionProgressViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func configure(viewModel: ChallengeConditionProgressViewModel) {
        self.viewModel = viewModel
        label?.attributedText = viewModel.progressAttributedString
        progressView?.progress = viewModel.progressValue
    }

    private func setup() {
        progressView?.trackTintColor = .dkGaugeGray
        progressView?.progressTintColor = DKUIColors.primaryColor.color
        label?.textColor = .black
        label?.font = DKUIFonts.primary.fonts(size: 16)
    }
}
