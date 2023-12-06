//
//  VehiclesViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 19/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitVehicleUI

class VehiclesViewController: UIViewController {
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var addVehicleButton: UIButton!
    private var viewModel = VehiclesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "vehicle_intro_header".keyLocalized()
        self.navigationItem.hidesBackButton = true
        addVehicleButton.configure(title: "vehicle_intro_button".keyLocalized(), style: .full)
        topLabel.attributedText = viewModel.getTitleAttributedText()
        descriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        topLabel.isUserInteractionEnabled = true
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDocAction)))
    }

    @objc func openDocAction() {
        if let docURL = URL(string: "drivekit_doc_ios_vehicle".keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    @IBAction func openAddVehicle() {
        let parentVC: UIViewController
        if let navController = self.navigationController {
            parentVC = navController
        } else {
            parentVC = self
        }
        let detectionMode = DriveKitVehicleUtils.getBestDetectionModeForNewVehicle()
        _ = DKVehiclePickerNavigationController(parentView: parentVC, detectionMode: detectionMode, showCancel: false) { [weak self] in
            self?.viewModel.areVehiclesConfigured { configured in
                if configured {
                    self?.navigationController?.setViewControllers([DashboardViewController()], animated: true)
                }
            }
        }
    }
}
