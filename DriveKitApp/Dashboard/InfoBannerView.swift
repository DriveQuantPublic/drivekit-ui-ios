//
//  InfoBannerView.swift
//  DriveKitApp
//
//  Created by David Bauduin on 10/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class InfoBannerView: UIControl, Nibable {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    private(set) var viewModel: InfoBannerViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.actionButton.isUserInteractionEnabled = false
    }

    func update(with viewModel: InfoBannerViewModel) {
        self.viewModel = viewModel
        self.backgroundColor = viewModel.backgroundColor
        self.iconView.tintColor = viewModel.color
        self.iconView.image = viewModel.icon
        self.titleLabel.textColor = viewModel.color
        self.titleLabel.text = viewModel.title
        if viewModel.hasAction {
            self.actionButton.tintColor = viewModel.color
            self.actionButton.isHidden = false
        } else {
            self.actionButton.isHidden = true
        }
    }
}
