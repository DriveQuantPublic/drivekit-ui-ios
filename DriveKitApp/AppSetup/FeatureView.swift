//
//  FeatureView.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class FeatureView: UIView, Nibable {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var infoButton: UIButton!
    private var viewModel: FeatureViewViewModel?
    private weak var parentViewController: UIViewController?

    func update(viewModel: FeatureViewViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController

        if let icon = viewModel.getIcon() {
            self.iconView.image = icon
            self.iconView.isHidden = false
        } else {
            self.iconView.image = nil
            self.iconView.isHidden = true
        }

        self.titleLabel.attributedText = viewModel.getTitle().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold)).color(.mainFontColor).build()
        self.descriptionLabel.attributedText = viewModel.getDescription().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.actionButton.setAttributedTitle(viewModel.getActionButtonTitle().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold)).color(.secondaryColor).uppercased().build(), for: .normal)

        if viewModel.hasInfo() {
            self.infoButton.configure(text: "ⓘ", style: .empty)
            self.infoButton.isHidden = false
        } else {
            self.infoButton.isHidden = true
        }
    }

    @IBAction func executeAction() {
        if let viewModel = viewModel, let parentViewController = self.parentViewController {
            viewModel.executeAction(viewController: parentViewController)
        }
    }
}
