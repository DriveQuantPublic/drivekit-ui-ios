//
//  DKDiagnosisHelper.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import CoreMotion
import UserNotifications

import DriveKitCommonUI

@objc public class DKDiagnosisHelper : NSObject {

    @objc public static let shared = DKDiagnosisHelper()
    private lazy var bluetoothManager = CBCentralManager()

    private override init() {
        super.init()
    }

    @objc public func isSensorActivated(_ sensor: DKSensorType) -> Bool {
        var isSensorActivated = false
        switch sensor {
            case .bluetooth:
                isSensorActivated = self.bluetoothManager.state != .poweredOff
            case .gps:
                isSensorActivated = CLLocationManager.locationServicesEnabled()
        }
        return isSensorActivated
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
                case .authorized, .provisional:
                    completion(.valid)
                @unknown default:
                    print("New case \"\(settings.authorizationStatus)\" in UNAuthorizationStatus. Need to manage it.")
                    completion(.invalid)
            }
        }
    }

    @objc public func isNetworkReachable() -> Bool {
        return DKReachability.isConnectedToNetwork()
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
                case .authorized:
                    permissionStatus = .valid
                case .notDetermined:
                    permissionStatus = .notDetermined
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
        switch CLLocationManager.authorizationStatus() {
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
