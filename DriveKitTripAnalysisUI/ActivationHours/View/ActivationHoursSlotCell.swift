//
//  ActivationHoursSlotCell.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class ActivationHoursSlotCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var slotTypeButton: UIButton!
    private var viewModel: ActivationHoursSlotCellViewModel?
    private weak var parentViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func configure(viewModel: ActivationHoursSlotCellViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController

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

    private func setupView() {
        self.descriptionLabel.text = "dk_working_hours_slot_disabled_desc".dkTripAnalysisLocalized()
    }

    @IBAction private func showMenu(_ sender: UIView) {
        if let parentViewController = self.parentViewController {
            let menu = ActivationHoursSlotTypeViewSelector(sourceView: sender)
            parentViewController.present(menu, animated: true)
        }
    }
}
