//
//  ActivityPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David David on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

class ActivityPermissionViewModel {

    weak var view: PermissionView? = nil

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.activity) {
            case .notDetermined:
                requestPermission()
            case .valid:
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
        DKDiagnosisHelper.shared.requestPermission(.activity)
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }

}
