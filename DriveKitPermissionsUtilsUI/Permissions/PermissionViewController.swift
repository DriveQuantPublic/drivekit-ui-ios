//
//  PermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class PermissionViewController : DKUIViewController {

    private var nextPermissionViews: [DKPermissionView]
    private let completionHandler: () -> Void

    init(nibName: String, nextPermissionViews: [DKPermissionView], completionHandler: @escaping () -> Void) {
        self.nextPermissionViews = nextPermissionViews
        self.completionHandler = completionHandler
        super.init(nibName: nibName, bundle: Bundle.permissionsUtilsUIBundle)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use designated initializer `init(nextPermissionViews:completionHandler:)`")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func next() {
        if self.nextPermissionViews.isEmpty {
            self.completionHandler()
        } else {
            if let navigationController = self.navigationController {
                let permissionView = self.nextPermissionViews.removeFirst()
                let permissionViewController = permissionView.getViewController(nextPermissionViews: self.nextPermissionViews, completionHandler: self.completionHandler)
                var updatedViewControllers = navigationController.viewControllers
                updatedViewControllers[updatedViewControllers.count - 1] = permissionViewController
                navigationController.setViewControllers(updatedViewControllers, animated: true)
            } else {
                // Should not happen. We should always be inside a UINavigationController.
                print("Unexpected state in \(String(describing: self))")
            }
        }
    }

}
