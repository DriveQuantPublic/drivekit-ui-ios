//
//  PermissionsViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 19/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitPermissionsUtilsUI

class PermissionsViewController: UIViewController {
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var permissionsButton: UIButton!
    private var viewModel = PermissionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "permissions_intro_header".keyLocalized()
        self.navigationItem.hidesBackButton = true
        permissionsButton.configure(title: "permissions_intro_button".keyLocalized(), style: .full)
        topLabel.attributedText = viewModel.getTitleAttributedText()
        descriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        topLabel.isUserInteractionEnabled = true
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDocAction)))
    }

    @objc func openDocAction() {
        if let docURL = URL(string: "drivekit_doc_ios_permissions_utils".keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    @IBAction func openPermissions() {
        DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity], parentViewController: self) {
            self.goToVehicles()
        }
    }

    func goToVehicles() {
        viewModel.shouldDisplayVehicle {[weak self] shouldDisplay in
            if shouldDisplay {
                let vehiclesVC = VehiclesViewController(nibName: "VehiclesViewController", bundle: nil)
                self?.navigationController?.pushViewController(vehiclesVC, animated: true)
            } else {
                self?.navigationController?.setViewControllers([DashboardViewController()], animated: true)
            }
        }
    }
}
