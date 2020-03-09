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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
    }
    
    func setupNavigation() {
        let dismissItem = UIBarButtonItem(title: "dk_cancel", style: .plain, target: self, action: #selector(self.didDismissManually))
        navigationItem.rightBarButtonItem = dismissItem
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let backImage = UIImage(named: "dk_back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(showPreviousStep), for: .touchUpInside)
        backButton.tintColor = DKUIColors.secondaryColor.color
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func showPreviousStep() {
         // self.viewModel.stepCoordinator?.showPreviousStep()
      }
    
    @objc func didDismissManually() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
