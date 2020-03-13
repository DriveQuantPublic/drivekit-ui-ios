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
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let backImage = DKImages.back.image
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(showPreviousStep), for: .touchUpInside)
        backButton.tintColor = DKUIColors.fontColorOnPrimaryColor.color
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func showPreviousStep() {
        self.viewModel.showPreviousStep()
    }
    
    @objc func didDismissManually() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
