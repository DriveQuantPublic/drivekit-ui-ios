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
    var parentView: UIViewController
    let navigationController: UINavigationController
    
    public init(parentView: UIViewController) {
        self.parentView = parentView
        self.navigationController = UINavigationController()
        self.setupNavigationBar()
        self.navigationController.modalPresentationStyle = .overFullScreen
        let viewModel = VehiclePickerViewModel(coordinator: self)
        self.showFirstStep(viewController: viewModel.getViewController())
    }
    
    func setupNavigationBar() {
        self.navigationController.navigationBar.barTintColor = parentView.navigationController?.navigationBar.barTintColor
        navigationController.navigationBar.isTranslucent = parentView.navigationController?.navigationBar.isTranslucent ?? false
        navigationController.navigationBar.titleTextAttributes = parentView.navigationController?.navigationBar.titleTextAttributes
        navigationController.navigationBar.tintColor = parentView.navigationController?.navigationBar.tintColor        
    }
    
    private func showFirstStep(viewController : UIViewController?) {
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
