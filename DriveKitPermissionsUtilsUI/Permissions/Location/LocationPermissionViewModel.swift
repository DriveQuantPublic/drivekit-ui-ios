//
//  LocationPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class LocationPermissionViewModel {

    weak var view: PermissionView? = nil

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        if DKDiagnosisHelper.shared.isLocationValid() {
            NotificationCenter.default.removeObserver(self)
            self.view?.next()
        } else {
            switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
                case .notDetermined, .phoneRestricted:
                    requestPermission()
                case .valid, .invalid:
                    break
            }
        }
    }

    func openSettings() {
        DKDiagnosisHelper.shared.openSettings()
    }


    @objc private func requestPermission() {
        DKDiagnosisHelper.shared.requestPermission(.location)
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }

}
