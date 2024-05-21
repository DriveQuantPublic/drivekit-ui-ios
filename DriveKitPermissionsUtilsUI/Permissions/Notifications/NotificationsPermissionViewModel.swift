//
//  NotificationsPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 17/05/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class NotificationsPermissionViewModel {

    weak var view: NotificationPermissionView?
    private(set) var displaySettingsButton: Bool = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.notifications) {
            case .notDetermined:
                displaySettingsButton = false
                self.view?.updateUI()
            case .valid:
                // swiftlint:disable:next notification_center_detachment
                NotificationCenter.default.removeObserver(self)
                self.view?.next()
            case .invalid, .phoneRestricted:
                displaySettingsButton = true
                self.view?.updateUI()
            @unknown default:
                break
        }
    }

    func openSettings() {
        DKDiagnosisHelper.shared.openSettings()
    }

    @objc func requestPermission() {
        DKDiagnosisHelper.shared.requestPermission(.notifications)
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }
}
