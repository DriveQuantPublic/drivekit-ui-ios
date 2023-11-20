//
//  DeleteAccountViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 22/09/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCoreModule

class DeleteAccountViewModel {
    private var completionHandler: ( (DeleteAccountStatus) -> Void)?

    init() {
        DriveKitDelegateManager.shared.register(delegate: self)
    }

    deinit {
        DriveKitDelegateManager.shared.unregister(delegate: self)
    }

    func logout() {
        DriveKitConfig.logout()
        if let appDelegate = UIApplication.shared.delegate, let appNavigationController = appDelegate.window??.rootViewController as? AppNavigationController {
            appNavigationController.setViewControllers([ApiKeyViewController()], animated: true)
        }
    }
    func deleteAccount(completion: @escaping (DeleteAccountStatus) -> Void) {
        self.completionHandler = completion
        DriveKit.shared.deleteAccount()
    }
}

extension DeleteAccountViewModel: DriveKitDelegate {
    public func driveKit(_ driveKit: DriveKit, accountDeletionCompleted status: DeleteAccountStatus) {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.completionHandler?(status)
                self.completionHandler = nil
            }
        }
    }
}
