//
//  ActivationHoursSlotCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitTripAnalysisModule

class ActivationHoursSlotCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var slotTypeButton: UIButton!
    private var viewModel: ActivationHoursSlotCellViewModel?
    private weak var parentViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.primaryColor.color
        self.descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.descriptionLabel.textColor = DKUIColors.warningColor.color
        self.slotTypeButton.setTitleColor(DKUIColors.primaryColor.color, for: .normal)
        self.slotTypeButton.backgroundColor = DKUIColors.neutralColor.color
        self.slotTypeButton.titleLabel?.font = DKStyles.button.style.applyTo(font: .primary)

        updateUI()
    }

    func configure(viewModel: ActivationHoursSlotCellViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        updateUI()
    }

    private func updateUI() {
        self.descriptionLabel.text = "dk_working_hours_slot_disabled_desc".dkTripAnalysisLocalized()

        if let viewModel = self.viewModel {
            let titleKey: String
            switch viewModel.slotType {
                case .inside:
                    titleKey = "dk_working_hours_slot_inside_title"
                case .outside:
                    titleKey = "dk_working_hours_slot_outside_title"
            }
            self.titleLabel.text = titleKey.dkTripAnalysisLocalized()

            let slotTypeKey: String
            let displayDescription: Bool
            switch viewModel.tripStatus {
                case .disabled:
                    slotTypeKey = "dk_working_hours_slot_mode_disabled_title"
                    displayDescription = true
                case .business:
                    slotTypeKey = "dk_working_hours_slot_mode_business_title"
                    displayDescription = false
                case .personal:
                    slotTypeKey = "dk_working_hours_slot_mode_personal_title"
                    displayDescription = false
            }
            self.slotTypeButton.setTitle(slotTypeKey.dkTripAnalysisLocalized(), for: .normal)
            self.descriptionLabel.isHidden = !displayDescription
        }
    }

    @IBAction private func showMenu(_ sender: UIView) {
        if let parentViewController = self.parentViewController {
            let menu = ActivationHoursSlotTypeViewSelector(sourceView: sender, selection: self.viewModel?.tripStatus ?? .disabled)
            menu.delegate = self
            parentViewController.present(menu, animated: true)
        }
    }
}

extension ActivationHoursSlotCell: ActivationHoursSlotTypeViewSelectorDelegate {
    func activationHoursSlotTypeViewSelector(_ selector: ActivationHoursSlotTypeViewSelector, didSelectTripStatus tripStatus: TripStatus) {
        selector.dismiss(animated: true)
        if let viewModel = self.viewModel {
            viewModel.tripStatus = tripStatus
            updateUI()
        }
    }
}
