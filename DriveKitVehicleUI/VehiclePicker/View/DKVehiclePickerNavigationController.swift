//
//  VehiclePickerNavigationController.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 05/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccess

public class DKVehiclePickerNavigationController : UINavigationController {
    
    let completion : (() -> ())?
    
    public init(parentView: UIViewController, detectionMode: DKDetectionMode = .disabled, vehicle: DKVehicle? = nil, completion : (() -> ())? = nil) {
        self.completion = completion
        let viewModel = VehiclePickerViewModel(detectionMode: detectionMode, previousVehicle: vehicle)
        super.init(rootViewController: viewModel.getViewController())
        viewModel.vehicleNavigationDelegate = self
        self.setupNavigationBar(parentView: parentView)
        self.modalPresentationStyle = .overFullScreen
        parentView.present(self, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNavigationBar(parentView: UIViewController) {
        self.navigationBar.barTintColor = parentView.navigationController?.navigationBar.barTintColor
        self.navigationBar.isTranslucent = parentView.navigationController?.navigationBar.isTranslucent ?? false
        self.navigationBar.titleTextAttributes = parentView.navigationController?.navigationBar.titleTextAttributes
        self.navigationBar.tintColor = parentView.navigationController?.navigationBar.tintColor
    }
    
    func showPrevious() {
        self.popViewController(animated: true)
    }
}

extension DKVehiclePickerNavigationController : VehicleNavigationDelegate {
    func showStep(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        self.show(viewController, sender: nil)
    }
}
