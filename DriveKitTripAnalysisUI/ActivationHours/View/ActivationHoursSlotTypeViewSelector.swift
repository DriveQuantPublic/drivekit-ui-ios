//
//  ActivationHoursSlotTypeViewSelector.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
import DriveKitTripAnalysisModule

class ActivationHoursSlotTypeViewSelector: UIViewController {
    @IBOutlet private weak var disabledButton: UIButton!
    @IBOutlet private weak var personalButton: UIButton!
    @IBOutlet private weak var businessButton: UIButton!
    weak var delegate: ActivationHoursSlotTypeViewSelectorDelegate?
    private var selection: TripStatus

    init(sourceView: UIView, selection: TripStatus) {
        self.selection = selection
        super.init(nibName: "ActivationHoursSlotTypeViewSelector", bundle: Bundle.tripAnalysisUIBundle)
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 200, height: 152)
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceView.bounds
        popoverPresentationController?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setup(selection: self.selection)
    }

    private func setup(selection: TripStatus) {
        self.disabledButton.setTitle("dk_working_hours_slot_mode_disabled_title".dkTripAnalysisLocalized(), for: .normal)
        self.personalButton.setTitle("dk_working_hours_slot_mode_personal_title".dkTripAnalysisLocalized(), for: .normal)
        self.businessButton.setTitle("dk_working_hours_slot_mode_business_title".dkTripAnalysisLocalized(), for: .normal)

        applyStyleTo(self.businessButton)
        applyStyleTo(self.disabledButton)
        applyStyleTo(self.personalButton)

        let selectedButton: UIButton
        switch selection {
            case .business:
                selectedButton = self.businessButton
            case .disabled:
                selectedButton = self.disabledButton
            case .personal:
                selectedButton = self.personalButton
        }
        selectButton(selectedButton)
    }

    private func applyStyleTo(_ button: UIButton) {
        button.setTitleColor(DKUIColors.primaryColor.color, for: .normal)
        button.titleLabel?.font = DKStyle(size: DKStyles.button.style.size, traits: nil).applyTo(font: .primary)
    }

    private func selectButton(_ button: UIButton) {
        button.titleLabel?.font = DKStyles.highlightSmall.style.applyTo(font: .primary)
    }

    @IBAction private func didSelectButton(_ button: UIButton) {
        selectButton(button)
        if let delegate = self.delegate {
            let selectedStatus: TripStatus
            if button == self.disabledButton {
                selectedStatus = .disabled
            } else if button == self.businessButton {
                selectedStatus = .business
            } else {
                selectedStatus = .personal
            }
            delegate.activationHoursSlotTypeViewSelector(self, didSelectTripStatus: selectedStatus)
        }
    }
}

extension ActivationHoursSlotTypeViewSelector: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

protocol ActivationHoursSlotTypeViewSelectorDelegate: AnyObject {
    func activationHoursSlotTypeViewSelector(_ selector: ActivationHoursSlotTypeViewSelector, didSelectTripStatus tripStatus: TripStatus)
}
