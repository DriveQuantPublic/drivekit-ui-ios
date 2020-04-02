//
//  VehiclePickerCoordinator.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccess

public class VehiclePickerCoordinator {
    let navigationController: UINavigationController
    var vehicle: DKVehicle?
    var detectionMode: DKDetectionMode
    var completion : (() -> ())? = nil
    
    public init(parentView: UIViewController, detectionMode: DKDetectionMode = .disabled, vehicle: DKVehicle? = nil, completion : (() -> ())? = nil) {
        self.detectionMode = detectionMode
        self.vehicle = vehicle
        self.completion = completion
        self.navigationController = UINavigationController()
        self.setupNavigationBar(parentView: parentView)
        self.navigationController.modalPresentationStyle = .overFullScreen
        let viewModel = VehiclePickerViewModel(coordinator: self)
        self.showFirstStep(parentView: parentView, viewController: viewModel.getViewController())
    }
    
    func setupNavigationBar(parentView: UIViewController) {
        self.navigationController.navigationBar.barTintColor = parentView.navigationController?.navigationBar.barTintColor
        navigationController.navigationBar.isTranslucent = parentView.navigationController?.navigationBar.isTranslucent ?? false
        navigationController.navigationBar.titleTextAttributes = parentView.navigationController?.navigationBar.titleTextAttributes
        navigationController.navigationBar.tintColor = parentView.navigationController?.navigationBar.tintColor        
    }
    
    private func showFirstStep(parentView: UIViewController, viewController : UIViewController?) {
        if let view = viewController {
            navigationController.viewControllers.append(view)
            view.modalPresentationStyle = .overFullScreen
            parentView.present(navigationController, animated: true)
        }
    }
    
    func showStep(viewController : UIViewController?) {
        if let view = viewController {
            view.modalPresentationStyle = .overFullScreen
            navigationController.show(view, sender: nil)
        }
    }
    
    func showPrevious() {
        navigationController.popViewController(animated: true)
    }
}
