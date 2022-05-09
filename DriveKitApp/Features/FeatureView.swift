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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconView.tintColor = DKUIColors.mainFontColor.color
    }

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

        self.titleLabel.attributedText = viewModel.getTitle().dkAttributedString().font(dkFont: .primary, style: DKStyles.highlightSmall.withSizeDelta(-2)).color(.mainFontColor).build()
        self.descriptionLabel.attributedText = viewModel.getDescription().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        self.actionButton.configure(text: viewModel.getActionButtonTitle().keyLocalized(), style: .empty)

        if viewModel.hasInfo() {
            self.infoButton.setAttributedTitle("ⓘ".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.secondaryColor).build(), for: .normal)
            self.infoButton.isHidden = false
        } else {
            self.infoButton.isHidden = true
        }
    }

    @IBAction func showInfo() {
        if let viewModel = viewModel, let parentViewController = self.parentViewController {
            viewModel.showInfo(parentViewController: parentViewController)
        }
    }

    @IBAction func executeAction() {
        if let viewModel = viewModel, let parentViewController = self.parentViewController {
            viewModel.executeAction(parentViewController: parentViewController)
        }
    }
}
