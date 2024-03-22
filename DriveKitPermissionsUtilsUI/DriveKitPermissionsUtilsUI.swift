// swiftlint:disable line_length
//
//  DriveKitPermissionsUtilsUI.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitCommonUI

@objc public class DriveKitPermissionsUtilsUI: NSObject {
    @objc public static let shared = DriveKitPermissionsUtilsUI()
    
    public var isBluetoothNeeded: Bool {
        if let bluetoothUsage = DriveKit.shared.modules.tripAnalysis?.bluetoothUsage {
            return bluetoothUsage != .none
        }
        return false
    }
    
    public private(set) var contactType = DKContactType.none
    private var stateByType = [StatusType: Bool]()

    @available(*, deprecated, message: "Logs are now enabled by default. To disable logging, just call DriveKit.shared.disableLogging()")
    public private(set) var showDiagnosisLogs = true

    private override init() {
        super.init()

        DKDiagnosisHelper.shared.delegate = self
        updateState()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc public func initialize() {
        DriveKitNavigationController.shared.permissionsUtilsUI = self
    }

    public func showPermissionViews(_ permissionViews: [DKPermissionView], parentViewController: UIViewController, completionHandler: @escaping () -> Void) {
        // Keep only needed permission views.
        let neededPermissionViews = permissionViews.filter { permissionView in
            let permissionType = permissionView.getPermissionType()
            switch permissionType {
                case .activity:
                    return !DKDiagnosisHelper.shared.isActivityValid() && DKDiagnosisHelper.shared.getPermissionStatus(permissionType) != .phoneRestricted // For activity permission, allow `.phoneRestricted` status because of a system bug (if the user allows access to Motion & Fitness in global settings, on coming back to the app, the status of this permission is still "restricted" instead of something else).
                case .location:
                    return !DKDiagnosisHelper.shared.isLocationValid()
                case .bluetooth:
                    return false
                @unknown default:
                    return false
            }
        }
        if neededPermissionViews.isEmpty {
            completionHandler()
        } else if let permissionView = neededPermissionViews.first {
            // Try to find a UINavigationController to push screens inside.
            var navigationController: UINavigationController?
            if let parentNavigationController = parentViewController as? UINavigationController {
                navigationController = parentNavigationController
            } else if let parentNavigationController = parentViewController.navigationController {
                navigationController = parentNavigationController
            }
            let permissionViewController = permissionView.getViewController(permissionViews: neededPermissionViews, completionHandler: completionHandler)
            permissionViewController.manageNavigation = true
            if let navigationController = navigationController {
                // A UINavigationController has been found, push screen inside.
                permissionViewController.isPresentedByModule = false
                navigationController.pushViewController(permissionViewController, animated: true)
            } else if neededPermissionViews.count == 1 {
                // No UINavigationController found and just only one screen to show -> Present it.
                permissionViewController.isPresentedByModule = true
                parentViewController.present(permissionViewController, animated: true, completion: nil)
            } else {
                // No UINavigationController found and several screens to show -> Create a UINavigationController to push them inside and present this navigation controller.
                permissionViewController.isPresentedByModule = true
                let navigationController = UINavigationController(rootViewController: permissionViewController)
                parentViewController.present(navigationController, animated: true, completion: nil)
            }
        }
    }

    @objc public func getDiagnosisViewController() -> UIViewController {
        updateState()
        return DiagnosisViewController()
    }

    @objc public func hasError() -> Bool {
        return self.stateByType.values.contains(false)
    }

    @objc public func getDiagnosisDescription() -> String {
        let locationSensorStatus = getStatusString("dk_perm_utils_app_diag_email_location_sensor", isValid: DKDiagnosisHelper.shared.isActivated(.gps))
        let locationPermissionStatus = getStatusString("dk_perm_utils_app_diag_email_location", isValid: (DKDiagnosisHelper.shared.getPermissionStatus(.location) == .valid))
        let locationAccuracy = getStatusString("dk_perm_utils_app_diag_email_location_accuracy", isValid: (DKDiagnosisHelper.shared.getLocationAccuracy() == .precise))
        let activityStatus = getStatusString(statusType: .activity, titleKey: "dk_perm_utils_app_diag_email_activity")
        let notificationStatus = getStatusString(statusType: .notification, titleKey: "dk_perm_utils_app_diag_email_notification")
        let networkStatus = getStatusString(statusType: .network, titleKey: "dk_perm_utils_app_diag_email_network")
        var info = [locationSensorStatus, locationPermissionStatus, locationAccuracy, activityStatus, notificationStatus, networkStatus]
        if self.isBluetoothNeeded {
            let bluetoothStatus = getStatusString(statusType: .bluetooth, titleKey: "dk_perm_utils_app_diag_email_bluetooth")
            info.append(bluetoothStatus)
        }
        let batteryOptimizationStatus = getStatusString("dk_perm_utils_app_diag_email_battery", isValid: !DKDiagnosisHelper.shared.isLowPowerModeEnabled(), validValue: "dk_perm_utils_app_diag_email_battery_disabled".dkPermissionsUtilsLocalized(), invalidValue: "dk_perm_utils_app_diag_email_battery_enabled".dkPermissionsUtilsLocalized())
        info.append(batteryOptimizationStatus)
        return info.joined(separator: "\n")
    }

    private func getStatusString(statusType: StatusType, titleKey: String) -> String {
        return getStatusString(titleKey, isValid: self.stateByType[statusType] ?? false)
    }

    private func getStatusString(_ titleKey: String, isValid: Bool, validValue: String = DKCommonLocalizable.yes.text(), invalidValue: String = DKCommonLocalizable.no.text()) -> String {
        return "\(titleKey.dkPermissionsUtilsLocalized()) \(isValid ? validValue : invalidValue)"
    }

    @available(*, deprecated, message: "This method is not used anymore.")
    @objc public func configureBluetooth(needed: Bool) {}

    @available(*, deprecated, message: "Logs are now enabled by default. To disable logging, just call DriveKit.shared.disableLogging()")
    @objc public func configureDiagnosisLogs(show: Bool) { }

    public func configureContactType(_ contactType: DKContactType) {
        self.contactType = contactType
    }

    @objc private func appDidBecomeActive() {
        updateState()
    }

    private func updateState() {
        let diagnosisHelper = DKDiagnosisHelper.shared
        // Activity.
        let isActivityUpdated = updateInternalState(.activity, isValid: diagnosisHelper.isActivityValid())
        // Bluetooth.
        let isBluetoothUpdated: Bool
        if self.isBluetoothNeeded {
            isBluetoothUpdated = updateInternalState(.bluetooth, isValid: diagnosisHelper.isBluetoothValid())
        } else {
            isBluetoothUpdated = false
        }
        // Location.
        let isLocationUpdated = updateInternalState(.location, isValid: diagnosisHelper.isLocationValid())
        // Network.
        let isNetworkUpdated = updateInternalState(.network, isValid: diagnosisHelper.isNetworkValid())
        // Notification.
        diagnosisHelper.isNotificationValid { isValid in
            let isNotificationUpdated = self.updateInternalState(.notification, isValid: isValid)

            if isActivityUpdated || isBluetoothUpdated || isLocationUpdated || isNetworkUpdated || isNotificationUpdated {
                // A state has been updated. Post notification.
                NotificationCenter.default.post(name: .sensorStateChangedNotification, object: nil)
            }
        }
    }

    private func updateInternalState(_ statusType: StatusType, isValid: Bool) -> Bool {
        let updated: Bool
        if self.stateByType[statusType] != isValid {
            self.stateByType[statusType] = isValid
            updated = true
        } else {
            updated = false
        }
        return updated
    }

    public func getDeviceConfigurationEventNotification() -> DKDiagnosisNotificationInfo? {
        return DKDeviceConfigurationEventNotificationManager.getNotificationInfo()
    }
}

public extension Notification.Name {
    static let sensorStateChangedNotification = Notification.Name("dk_sensorStateChanged")
}

extension Bundle {
    static let permissionsUtilsUIBundle = Bundle(identifier: "com.drivequant.drivekit-permissions-utils-ui")
}

extension String {
    public func dkPermissionsUtilsLocalized() -> String {
        return self.dkLocalized(tableName: "PermissionsUtilsLocalizables", bundle: Bundle.permissionsUtilsUIBundle ?? .main)
    }
}

extension DriveKitPermissionsUtilsUI: DriveKitPermissionsUtilsUIEntryPoint {
    public func getActivityPermissionViewController(_ completionHandler: @escaping () -> Void) -> UIViewController {
        return DKPermissionView.activity.getViewController(permissionViews: [.activity], completionHandler: completionHandler)
    }

    public func getLocationPermissionViewController(_ completionHandler: @escaping () -> Void) -> UIViewController {
        return DKPermissionView.location.getViewController(permissionViews: [.location], completionHandler: completionHandler)
    }
}

extension DriveKitPermissionsUtilsUI: DKDiagnosisHelperDelegate {
    public func bluetoothStateChanged() {
        updateState()
    }
}

extension DKDiagnosisHelper {
    public func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }
    
    public func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

// MARK: - Objective-C extension

extension DriveKitPermissionsUtilsUI {
    @objc(showPermissionViews:parentViewController:completionHandler:) // Usage example: [DriveKitPermissionsUtilsUI.shared showPermissionViews:@[ @(DKPermissionViewLocation), @(DKPermissionViewActivity) ] parentViewController: ... completionHandler: ...];
    public func objc_showPermissionViews(_ permissionViews: [Int], parentViewController: UIViewController, completionHandler: @escaping () -> Void) {
        showPermissionViews(permissionViews.map({ DKPermissionView(rawValue: $0)! }), parentViewController: parentViewController, completionHandler: completionHandler)
    }

    @objc(configureMailContactType:)
    public func objc_configureContactType(contentMail: DKContentMail) {
        self.configureContactType(.email(contentMail))
    }

    @objc(configureWebContactType:)
    public func objc_configureContactType(contactUrl: URL) {
        self.configureContactType(.web(contactUrl))
    }
}

@objc(DKUIPermissionsUtilsInitializer)
class DKUIPermissionsUtilsInitializer: NSObject {
    @objc static func initUI() {
        DriveKitPermissionsUtilsUI.shared.initialize()
    }
}
