//
//  AppNavigationController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 07/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitPermissionsUtilsUI

class AppNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewController()
    }

    func setupViewController() {
        if DriveKit.shared.isUserConnected() {
            self.showLoader(message: "sync_trips_loading_message".keyLocalized())
            self.isNavigationBarHidden = true
            SynchroServicesManager.syncModules([.trips, .challenge, .userInfo, .vehicle], stepCompletion:  { [weak self] status, remainingServices in
                self?.hideLoader()
                if let service = remainingServices.first {
                    switch service {
                    case .userInfo:
                        self?.showLoader(message: "sync_user_info_loading_message".keyLocalized())
                    case .vehicle:
                        self?.showLoader(message: "sync_vehicles_loading_message".keyLocalized())
                    case .challenge:
                        self?.showLoader(message: "sync_challenge_loading_message".keyLocalized())
                    default:
                        break
                    }
                }
            }) { [weak self] _ in
                if let self = self {
                    DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity], parentViewController: self) {
                        self.isNavigationBarHidden = false
                        self.goToDashboard()
                    }
                }
            }
        } else {
            let apiVC = ApiKeyViewController()
            self.setViewControllers([apiVC], animated: false)
        }
    }

    func goToDashboard() {
        self.setViewControllers([DashboardViewController()], animated: false)
    }
}
