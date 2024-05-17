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

    weak var view: PermissionView?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.notifications) {
            case .notDetermined:
                requestPermission()
            case .valid:
                // swiftlint:disable:next notification_center_detachment
                NotificationCenter.default.removeObserver(self)
                self.view?.next()
            case .invalid, .phoneRestricted:
                break
            @unknown default:
                break
        }
    }

    func openSettings() {
        DKDiagnosisHelper.shared.openSettings()
    }

    @objc private func requestPermission() {
        DKDiagnosisHelper.shared.requestPermission(.notifications)
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }
}
