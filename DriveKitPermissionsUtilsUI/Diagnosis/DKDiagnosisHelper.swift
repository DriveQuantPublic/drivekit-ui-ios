//
//  DKDiagnosisHelper.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import CoreMotion
import UserNotifications

import DriveKitCommonUI

@objc public class DKDiagnosisHelper : NSObject {

    @objc public static let shared = DKDiagnosisHelper()
    weak var delegate: DiagnosisHelperDelegate? = nil
    private lazy var requestPermissionHelper = RequestPermissionHelper()
    private lazy var locationManager = CLLocationManager()
    private lazy var bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:false])

    private override init() {
        super.init()
    }

    @objc public func isSensorActivated(_ sensor: DKSensorType) -> Bool {
        var isSensorActivated = false
        switch sensor {
            case .bluetooth:
                isSensorActivated = self.bluetoothManager.state != .poweredOff && self.bluetoothManager.state != .unknown
            case .gps:
                isSensorActivated = CLLocationManager.locationServicesEnabled()
        }
        return isSensorActivated
    }

    @objc public func isLowPowerModeEnabled() -> Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    @objc public func getPermissionStatus(_ permissionType: DKPermissionType) -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        switch permissionType {
            case .activity:
                permissionStatus = getActivityStatus()
            case .bluetooth:
                permissionStatus = getBluetoothStatus()
            case .location:
                permissionStatus = getLocationStatus()
        }
        return permissionStatus
    }

    @objc public func getNotificationPermissionStatus(completion: @escaping (DKPermissionStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    completion(.invalid)
                case .notDetermined:
                    completion(.notDetermined)
                case .authorized, .provisional, .ephemeral:
                    completion(.valid)
                @unknown default:
                    print("New case \"\(settings.authorizationStatus)\" in UNAuthorizationStatus. Need to manage it.")
                    completion(.invalid)
            }
        }
    }

    @objc public func getLocationAccuracy() -> DKLocationAccuracy {
        if #available(iOS 14.0, *) {
            let authorizationStatus = self.locationManager.authorizationStatus
            switch authorizationStatus {
                case .notDetermined, .denied, .restricted:
                    return .unknown
                case .authorizedAlways, .authorizedWhenInUse:
                    switch self.locationManager.accuracyAuthorization {
                        case .fullAccuracy:
                            return .precise
                        case .reducedAccuracy:
                            return .approximative
                        @unknown default:
                            print("New case \"\(self.locationManager.accuracyAuthorization)\" in CLAccuracyAuthorization. Need to manage it.")
                            return .unknown
                    }
                @unknown default:
                    print("New case \"\(authorizationStatus)\" in CLAuthorizationStatus. Need to manage it.")
                    return .unknown
            }
        } else {
            return .precise
        }
    }

    @objc public func isNetworkReachable() -> Bool {
        return DKReachability.isConnectedToNetwork()
    }

    @objc public func requestPermission(_ permissionType: DKPermissionType) {
        self.requestPermissionHelper.requestPermission(permissionType)
    }


    @objc public func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }


    @objc public func isActivityValid() -> Bool {
        return getPermissionStatus(.activity) == .valid
    }

    @objc public func isBluetoothValid() -> Bool {
        if DriveKitPermissionsUtilsUI.shared.isBluetoothNeeded {
            return isSensorActivated(.bluetooth) && getPermissionStatus(.bluetooth) == .valid
        } else {
            return true
        }
    }

    @objc public func isLocationValid() -> Bool {
        return isSensorActivated(.gps) && getPermissionStatus(.location) == .valid && getLocationAccuracy() == .precise
    }

    @objc public func isNetworkValid() -> Bool {
        return isNetworkReachable()
    }

    @objc public func isNotificationValid(completion: @escaping (Bool) -> Void) {
        getNotificationPermissionStatus { permissionStatus in
            DispatchQueue.main.async {
                completion(permissionStatus == .valid)
            }
        }
    }


    private func getActivityStatus() -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        if #available(iOS 11.0, *) {
            switch CMMotionActivityManager.authorizationStatus() {
                case .notDetermined:
                    permissionStatus = .notDetermined
                case .authorized:
                    permissionStatus = .valid
                case .restricted:
                    permissionStatus = .phoneRestricted
                case .denied:
                    permissionStatus = .invalid
                    break
                @unknown default:
                    print("New case \"\(CMMotionActivityManager.authorizationStatus())\" in CMAuthorizationStatus. Need to manage it.")
                    permissionStatus = .invalid
            }
        } else {
            if CMSensorRecorder.isAuthorizedForRecording() {
                permissionStatus = .valid
            } else {
                permissionStatus = .notDetermined // Is it possible to know if status is `notDetermined` or `invalid` on iOS < 11?
            }
        }
        return permissionStatus
    }

    private func getBluetoothStatus() -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        if #available(iOS 13.0, *) {
            let authorization: CBManagerAuthorization
            if #available(iOS 13.1, *) {
                authorization = CBCentralManager.authorization
            } else {
                authorization = self.bluetoothManager.authorization
            }
            switch authorization {
                case .allowedAlways:
                    permissionStatus = .valid
                case .notDetermined:
                    permissionStatus = .notDetermined
                case .denied, .restricted :
                    permissionStatus = .invalid
                @unknown default:
                    print("New case \"\(authorization)\" in CBManagerAuthorization. Need to manage it.")
                    permissionStatus = .invalid
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
                case .authorized, .notDetermined:
                    permissionStatus = .valid
                case .denied, .restricted:
                    permissionStatus = .invalid
                @unknown default:
                    print("New case \"\(CBPeripheralManager.authorizationStatus())\" in CBPeripheralManagerAuthorizationStatus. Need to manage it.")
                    permissionStatus = .invalid
            }
        }
        return permissionStatus
    }

    private func getLocationStatus() -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch authorizationStatus {
            case .notDetermined:
                permissionStatus = .notDetermined
            case .authorizedAlways:
                permissionStatus = .valid
            case .denied:
                if isSensorActivated(.gps) {
                    permissionStatus = .invalid
                } else {
                    permissionStatus = .phoneRestricted
                }
            case .authorizedWhenInUse, .restricted:
                permissionStatus = .invalid
            @unknown default:
                print("New case \"\(CLLocationManager.authorizationStatus())\" in CLAuthorizationStatus. Need to manage it.")
                permissionStatus = .invalid
        }
        return permissionStatus
    }

}

extension DKDiagnosisHelper : CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.delegate?.bluetoothStateChanged()
    }
}

protocol DiagnosisHelperDelegate : AnyObject {
    func bluetoothStateChanged()
}
