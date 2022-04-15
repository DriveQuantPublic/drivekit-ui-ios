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
                var missingPermissions: [DKPermissionView] = []
                if DKDiagnosisHelper.shared.getPermissionStatus(.location) != .valid {
                    missingPermissions.append(.location)
                }
                if DKDiagnosisHelper.shared.getPermissionStatus(.activity) != .valid {
                    missingPermissions.append(.activity)
                }
                if missingPermissions.count > 0, let self = self {
                    DriveKitPermissionsUtilsUI.shared.showPermissionViews(missingPermissions, parentViewController: self) {
                        self.goToDashboard()
                    }

                } else {
                    self?.goToDashboard()
                }
            }
        } else {
            let apiVC = ApiKeyViewController(nibName: "ApiKeyViewController", bundle: nil)
            self.setViewControllers([apiVC], animated: false)
        }
    }

    func goToDashboard() {
        #warning("to be replaced by the dashboard view")
        self.setViewControllers([UIViewController()], animated: false)

    }
}
