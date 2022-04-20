//
//  AppNavigationController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 07/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

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
            self.setViewControllers([DashboardViewController()], animated: false)
        } else {
            let apiVC = ApiKeyViewController(nibName: "ApiKeyViewController", bundle: nil)
            self.setViewControllers([apiVC], animated: false)
        }
    }
}
