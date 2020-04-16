//
//  LocationPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class LocationPermissionViewModel : NSObject {

    weak var view: PermissionView? = nil

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
            case .notDetermined, .phoneRestricted:
                requestPermission()
            case .valid:
                NotificationCenter.default.removeObserver(self)
                self.view?.next()
            case .invalid:
                break
        }
    }

    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }


    @objc private func requestPermission() {
        DKDiagnosisHelper.shared.requestPermission(.location)
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }

}
