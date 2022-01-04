//
//  ActivationHoursSlotTypeViewSelector.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class ActivationHoursSlotTypeViewSelector: UIViewController {
    init(sourceView: UIView) {
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
}

extension ActivationHoursSlotTypeViewSelector: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
