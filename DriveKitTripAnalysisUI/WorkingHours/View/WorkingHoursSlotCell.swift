//
//  WorkingHoursSlotCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitTripAnalysisModule

class WorkingHoursSlotCell: UITableViewCell {
    @IBOutlet private weak var legendLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var slotTypeButton: UIButton!
    @IBOutlet private weak var selectImageView: UIImageView!
    private var viewModel: WorkingHoursSlotCellViewModel?
    private weak var parentViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.primaryColor.color
        self.descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.descriptionLabel.textColor = DKUIColors.warningColor.color
        self.slotTypeButton.setTitleColor(DKUIColors.mainFontColor.color, for: .normal)
        self.slotTypeButton.backgroundColor = DKUIColors.neutralColor.color
        self.slotTypeButton.titleLabel?.font = DKStyles.button.withSizeDelta(-2).applyTo(font: .primary)
        self.selectImageView.image = DKImages.arrowDown.image
        self.selectImageView.tintColor = DKUIColors.complementaryFontColor.color

        updateUI()
    }

    func configure(viewModel: WorkingHoursSlotCellViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        updateUI()
    }

    private func updateUI() {
        self.descriptionLabel.text = "dk_working_hours_slot_disabled_desc".dkTripAnalysisLocalized()

        if let viewModel = self.viewModel {
            self.legendLabel.textColor = viewModel.getSlotColor()
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
            switch viewModel.timeSlotStatus {
                case .disabled:
                    slotTypeKey = "dk_working_hours_slot_mode_disabled_title"
                    displayDescription = true
                case .business:
                    slotTypeKey = "dk_working_hours_slot_mode_business_title"
                    displayDescription = false
                case .personal:
                    slotTypeKey = "dk_working_hours_slot_mode_personal_title"
                    displayDescription = false
                @unknown default:
                    slotTypeKey = ""
                    displayDescription = false
            }
            self.slotTypeButton.setTitle(slotTypeKey.dkTripAnalysisLocalized(), for: .normal)
            self.descriptionLabel.isHidden = !displayDescription
        }
    }

    @IBAction private func showMenu(_ sender: UIView) {
        if let parentViewController = self.parentViewController {
            let menu = WorkingHoursSlotTypeViewSelector(sourceView: sender, selection: self.viewModel?.timeSlotStatus ?? .disabled)
            menu.delegate = self
            parentViewController.present(menu, animated: true)
        }
    }
}

extension WorkingHoursSlotCell: WorkingHoursSlotTypeViewSelectorDelegate {
    func workingHoursSlotTypeViewSelector(_ selector: WorkingHoursSlotTypeViewSelector, didSelectTimeSlotStatus timeSlotStatus: DKWorkingHoursTimeSlotStatus) {
        selector.dismiss(animated: true)
        if let viewModel = self.viewModel {
            viewModel.timeSlotStatus = timeSlotStatus
            updateUI()
        }
    }
}
