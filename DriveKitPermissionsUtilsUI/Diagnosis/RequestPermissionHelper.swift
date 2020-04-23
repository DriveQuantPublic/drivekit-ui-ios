//
//  RequestPermissionHelper.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 16/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import CoreMotion
import UserNotifications

class RequestPermissionHelper : NSObject {

    private lazy var bluetoothManager = CBCentralManager()
    private let locationManager = CLLocationManager()
    private let motionActivityManager = CMMotionActivityManager()

    override init() {
        super.init()

        self.locationManager.delegate = self
    }

    func requestPermission(_ permissionType: DKPermissionType) {
        switch permissionType {
            case .activity:
                self.requestActivityPermission()
            case .bluetooth:
                self.requestBluetoothPermission()
            case .location:
                self.requestLocationPermission()
        }
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: []) { (granted, error) in
            
        }
    }


    private func requestActivityPermission() {
        if DKDiagnosisHelper.shared.getPermissionStatus(.activity) == .notDetermined {
            self.motionActivityManager.startActivityUpdates(to: .main) { (_) in
                
            }
            self.motionActivityManager.stopActivityUpdates()
        }
    }

    private func requestBluetoothPermission() {
        // Accessing state of BluetoothManager may show a system dialog to enable it.
        let _ = self.bluetoothManager.state
    }
    
    private func requestLocationPermission() {
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
    
}


extension RequestPermissionHelper : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

}
