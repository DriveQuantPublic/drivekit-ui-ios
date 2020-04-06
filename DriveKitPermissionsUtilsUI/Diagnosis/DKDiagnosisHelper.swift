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

    @objc public func isSensorActivated(_ sensor: DKSensorType) -> Bool {
        var isSensorActivated = false
        switch sensor {
            case .bluetooth:
                isSensorActivated = self.bluetoothManager.state != .poweredOff
                break
            case .gps:
                isSensorActivated = CLLocationManager.locationServicesEnabled()
                break
        }
        return isSensorActivated
    }

    @objc public func getPermissionStatus(_ permissionType: DKPermissionType) -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        switch permissionType {
            case .activity:
                permissionStatus = getActivityStatus()
                break
            case .bluetooth:
                permissionStatus = getBluetoothStatus()
                break
            case .location:
                permissionStatus = getLocationStatus()
                break
        }
        return permissionStatus
    }

    @objc public func getNotificationPermissionStatus(completion: @escaping (DKPermissionStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    completion(.invalid)
                    break
                case .notDetermined:
                    completion(.notDetermined)
                    break
                default:
                    completion(.valid)
                    break
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
                    break
                case .authorized:
                    permissionStatus = .valid
                    break
                default:
                    permissionStatus = .invalid
                    break
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
                    break
                case .notDetermined:
                    permissionStatus = .notDetermined
                    break
                default :
                    permissionStatus = .invalid
                    break
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
                case .authorized:
                    permissionStatus = .valid
                case .notDetermined:
                    permissionStatus = .notDetermined
                    break
                default:
                    permissionStatus = .invalid
                    break
            }
        }
        return permissionStatus
    }

    private func getLocationStatus() -> DKPermissionStatus {
        var permissionStatus: DKPermissionStatus
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                permissionStatus = .notDetermined
                break
            case .authorizedAlways:
                permissionStatus = .valid
                break
            default:
                permissionStatus = .invalid
                break
        }
        return permissionStatus
    }

}
