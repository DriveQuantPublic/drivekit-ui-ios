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
import DriveKitVehicleModule

class AppNavigationController: UINavigationController {
    static let alreadyOnboardedKey = "DriveKitApp.alreadyOnboarded"
    static var alreadyOnboarded: Bool {
        get {
            DriveKitCoreUserDefaults.getPrimitiveType(key: alreadyOnboardedKey) ?? false
        }
        set {
            DriveKitCoreUserDefaults.setPrimitiveType(
                key: alreadyOnboardedKey,
                value: newValue)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewController()
    }

    func setupViewController() {
        configure()
        if DriveKit.shared.isUserConnected() {
            self.showLoader(message: "sync_trips_loading_message".keyLocalized())
            self.isNavigationBarHidden = true
            SynchroServicesManager.syncModules(
                [.trips, .challenge, .userInfo, .vehicle],
                stepCompletion: { [weak self] _, remainingServices in
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
                }, completion: { [weak self] _ in
                    if let self = self {
                        self.hideLoader()
                        DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity, .notifications], parentViewController: self) {
                            self.isNavigationBarHidden = false
                            DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: .cache) { _, vehicles in
                                DispatchQueue.dispatchOnMainThread {
                                    if vehicles.isEmpty {
                                        let vehiclesVC = VehiclesViewController(nibName: "VehiclesViewController", bundle: nil)
                                        self.setViewControllers([vehiclesVC], animated: false)
                                    } else {
                                        self.goToDashboard()
                                    }
                                }
                            }
                        }
                    }
                })
        } else {
            let apiVC = ApiKeyViewController()
            self.setViewControllers([apiVC], animated: false)
        }
    }

    func goToDashboard() {
        self.setViewControllers([DashboardViewController()], animated: false)
    }
}
