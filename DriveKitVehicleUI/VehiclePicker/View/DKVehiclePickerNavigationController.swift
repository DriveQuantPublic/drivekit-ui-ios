//
//  VehiclePickerNavigationController.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 05/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

public class DKVehiclePickerNavigationController: UINavigationController {
    let completion: (() -> ())?
    
    public init(parentView: UIViewController, detectionMode: DKDetectionMode = .disabled, vehicle: DKVehicle? = nil, showCancel: Bool = true, completion: (() -> ())? = nil) {
        self.completion = completion
        let viewModel = VehiclePickerViewModel(detectionMode: detectionMode, previousVehicle: vehicle, showCancel: showCancel)
        let firstViewController = viewModel.getViewController()
        super.init(nibName: nil, bundle: .vehicleUIBundle)
        viewModel.vehicleNavigationDelegate = self
        self.setupNavigationBar(parentView: parentView)
        self.modalPresentationStyle = .overFullScreen
        self.pushViewController(firstViewController, animated: true)
        parentView.present(self, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DriveKitUI.shared.trackScreen(tagKey: "dk_tag_vehicles_add", viewController: self)
    }
    
    func setupNavigationBar(parentView: UIViewController) {
        if let navigationBar = parentView.navigationController?.navigationBar {
            self.navigationBar.isTranslucent = navigationBar.isTranslucent
            if #available(iOS 15.0, *) {
                self.navigationBar.standardAppearance = navigationBar.standardAppearance
                self.navigationBar.scrollEdgeAppearance = navigationBar.scrollEdgeAppearance
            } else if #available(iOS 13.0, *) {
                self.navigationBar.standardAppearance = navigationBar.standardAppearance
            } else {
                self.navigationBar.titleTextAttributes = navigationBar.titleTextAttributes
            }
            self.navigationBar.barTintColor = navigationBar.barTintColor
            self.navigationBar.tintColor = navigationBar.tintColor
        }
    }
    
    func showPrevious() {
        self.popViewController(animated: true)
    }
    
    public func endVehiclePicker() {
        dismiss(animated: true, completion: nil)
        if let completion = completion {
            completion()
        }
    }
}

extension DKVehiclePickerNavigationController: VehicleNavigationDelegate {
    func showStep(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        self.show(viewController, sender: nil)
    }
}
