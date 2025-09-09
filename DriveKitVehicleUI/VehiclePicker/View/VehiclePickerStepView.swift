//
//  VehiclePickerStepsDelegate.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerStepView: DKUIViewController {
    var viewModel: VehiclePickerStepViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.title = self.viewModel.getTitle()
    }

    func setupNavigation() {
        if viewModel.pickerViewModel.showCancel {
            let dismissItem = UIBarButtonItem(title: DKCommonLocalizable.cancel.text(), style: .plain, target: self, action: #selector(self.didDismissManually))
            dismissItem.applyStyle()
            navigationItem.rightBarButtonItem = dismissItem
        }
        self.configureBackButton(selector: #selector(showPreviousStep))
    }

    @objc private func showPreviousStep() {
        if let step = self.viewModel.pickerViewModel.previousSteps.last {
            self.viewModel.pickerViewModel.currentStep = step
            self.viewModel.pickerViewModel.previousSteps.removeLast(1)
            (self.navigationController as? DKVehiclePickerNavigationController)?.showPrevious()
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
            (self.navigationController as? DKVehiclePickerNavigationController)?.completion?()
        }
    }

    @objc func didDismissManually() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        (self.navigationController as? DKVehiclePickerNavigationController)?.completion?()
    }
}
