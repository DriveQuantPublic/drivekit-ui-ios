//
//  ActivityPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David David on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import CoreMotion

class ActivityPermissionViewModel : NSObject {

    weak var view: ActivityPermissionView? = nil
    private let motionActivityManager = CMMotionActivityManager()

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.activity) {
            case .notDetermined:
                askAuthorization()
                break
            case .valid:
                NotificationCenter.default.removeObserver(self)
                self.view?.next()
                break
            default:
                break
        }
    }

    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }


    @objc private func askAuthorization() {
        if DKDiagnosisHelper.shared.getPermissionStatus(.activity) == .notDetermined {
            self.motionActivityManager.startActivityUpdates(to: .main) { (motionActivity) in
                self.checkState()
            }
            self.motionActivityManager.stopActivityUpdates()
        }
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }

}


protocol ActivityPermissionView : PermissionView {

}
