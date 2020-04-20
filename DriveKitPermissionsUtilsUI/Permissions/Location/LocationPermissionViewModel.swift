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

    weak var view: PermissionView? = nil
    private let locationManager = CLLocationManager()

    override init() {
        super.init()

        self.locationManager.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func checkState() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
            case .notDetermined, .phoneRestricted:
                askAuthorization()
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


    @objc private func askAuthorization() {
        switch DKDiagnosisHelper.shared.getPermissionStatus(.location) {
            case .notDetermined:
                if #available(iOS 13.0, *) {
                    self.locationManager.requestWhenInUseAuthorization()
                } else {
                    self.locationManager.requestAlwaysAuthorization()
                }
            case .phoneRestricted:
                // Request location to try to display a system alert to redirect to phone's settings.
                self.locationManager.requestLocation()
            case .invalid, .valid:
                break
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

}
