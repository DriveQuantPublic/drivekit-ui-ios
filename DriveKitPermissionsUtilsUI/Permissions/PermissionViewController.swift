// swiftlint:disable all
//
//  PermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class PermissionViewController: DKUIViewController {

    var isPresentedByModule: Bool = false
    var manageNavigation: Bool = false
    fileprivate var permissionViews: [DKPermissionView] // Contains current permission view and the next ones, if exist.
    fileprivate let completionHandler: () -> Void

    init(nibName: String, permissionViews: [DKPermissionView], completionHandler: @escaping () -> Void) {
        self.permissionViews = permissionViews
        self.completionHandler = completionHandler
        super.init(nibName: nibName, bundle: Bundle.permissionsUtilsUIBundle)

        self.modalPresentationStyle = .overFullScreen
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use designated initializer `init(permissionViews:completionHandler:)`")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController != nil {
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
        }
    }

}

extension PermissionViewController: PermissionView {

    func next() {
        // Remove current permission view from the list.
        if !self.permissionViews.isEmpty {
            self.permissionViews.removeFirst()
        }

        if let nextPermissionView = self.permissionViews.first {
            guard let navigationController = self.navigationController else {
                // Should not happen. We should always be inside a UINavigationController.
                print("Unexpected state in \(String(describing: self))")
                return
            }
            let permissionViewController = nextPermissionView.getViewController(permissionViews: self.permissionViews, completionHandler: self.completionHandler)
            permissionViewController.isPresentedByModule = self.isPresentedByModule
            permissionViewController.manageNavigation = self.manageNavigation
            var updatedViewControllers = navigationController.viewControllers
            if updatedViewControllers.last as? PermissionViewController != nil {
                updatedViewControllers[updatedViewControllers.count - 1] = permissionViewController
                navigationController.setViewControllers(updatedViewControllers, animated: true)
            } else {
                navigationController.pushViewController(permissionViewController, animated: true)
            }
        } else {
            if self.manageNavigation, let navigationController = self.navigationController, navigationController.viewControllers.last as? PermissionViewController != nil {
                navigationController.popViewController(animated: true)
            }
            if self.isPresentedByModule && self.presentingViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
            self.completionHandler()
        }
    }

}
