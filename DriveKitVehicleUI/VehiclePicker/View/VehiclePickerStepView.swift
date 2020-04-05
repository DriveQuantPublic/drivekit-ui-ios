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
    
    var viewModel : VehiclePickerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.title = self.viewModel.getTitle()
    }
    
    func setupNavigation() {
        let dismissItem = UIBarButtonItem(title: DKCommonLocalizable.cancel.text(), style: .plain, target: self, action: #selector(self.didDismissManually))
        navigationItem.rightBarButtonItem = dismissItem
        self.configureBackButton(selector: #selector(showPreviousStep))
    }
    
    @objc private func showPreviousStep() {
        if let step = self.viewModel.previousSteps.last {
            self.viewModel.currentStep = step
            self.viewModel.previousSteps.removeLast(1)
            (self.navigationController as! DKVehiclePickerNavigationController).showPrevious()
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
            (self.navigationController as! DKVehiclePickerNavigationController).completion?()
        }
    }
    
    @objc func didDismissManually() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        (self.navigationController as! DKVehiclePickerNavigationController).completion?()
    }
}
