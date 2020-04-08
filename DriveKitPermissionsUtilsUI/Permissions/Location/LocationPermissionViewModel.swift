//
//  LocationPermissionViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionViewModel : NSObject {

    weak var view: LocationPermissionView? = nil
    private let locationManager = CLLocationManager()

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
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
        if DKDiagnosisHelper.shared.getPermissionStatus(.location) == .notDetermined {
            if #available(iOS 13.0, *) {
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                self.locationManager.requestAlwaysAuthorization()
            }
            self.locationManager.delegate = self
        }
    }

    @objc private func appDidBecomeActive() {
        checkState()
    }

}


extension LocationPermissionViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkState()
    }

}


protocol LocationPermissionView : PermissionView {

}
