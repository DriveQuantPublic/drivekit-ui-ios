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
        self.viewModel.showPreviousStep()
    }
    
    @objc func didDismissManually() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.viewModel.coordinator.completion?()
    }
}
