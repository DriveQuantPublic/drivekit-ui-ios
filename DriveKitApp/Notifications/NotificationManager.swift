// swiftlint:disable all
//
//  NotificationManager.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import CoreLocation
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataUI
import DriveKitTripAnalysisModule
import DriveKitTripAnalysisUI
import UserNotifications
import DriveKitPermissionsUtilsUI

class NotificationManager: NSObject {
    private static let shared = NotificationManager()
    private static let delay = 2.0

    static func configure() {
        // Configure NotificationManager shared instance:
        NotificationManager.shared.configure()

        // Request permission to present notifications:
        requestNotificationPermission()

        // Configure notifications, adding actions to some notifications:
        configureNotifications()
    }

    static func reset() {
        NotificationManager.shared.reset()
    }

    static func sendNotification(_ notification: NotificationType, userInfo: [String: Any]? = nil) {
        if notification.channel.isEnabled {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            if let categoryIdentifier = notification.categoryIdentifier {
                content.categoryIdentifier = categoryIdentifier
            }
            if let userInfo = userInfo {
                content.userInfo = userInfo
            }
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: NotificationManager.delay, repeats: false)
            let request = UNNotificationRequest(identifier: notification.identifier,
                                                content: content,
                                                trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    static func removeNotification(_ type: NotificationType) {
        removeNotifications([type.identifier])
    }

    static func removeNotifications(_ types: [NotificationType]) {
        removeNotifications(types.map { $0.identifier })
    }

    static func removeNotifications(_ identifiers: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    private static func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    private static func configureNotifications() {
        var actionList: [
            NotificationAction.TripAnalysis] = []
        
        if DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip {
            actionList = [
                .postpone(.tenMinutes),
                .postpone(.thirtyMinutes),
                .postpone(.oneHour),
                .postpone(.twoHours),
                .postpone(.fourHours),
                .analyze
            ]
        }
        let notificationActions = actionList.map {
            UNNotificationAction(identifier: $0.identifier,
                                 title: $0.title,
                                 options: [])
        }
        let notificationCategory = UNNotificationCategory(
            identifier: NotificationCategory.TripAnalysis.start.identifier,
            actions: notificationActions,
            intentIdentifiers: [],
            options: [])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([notificationCategory])
    }

    private func configure() {
        DriveKit.shared.registerNotificationDelegate(self)
        DriveKitTripAnalysis.shared.addTripListener(self)
        DriveKit.shared.addDeviceConfigurationDelegate(self)
    }

    private func reset() {
        DriveKit.shared.unregisterNotificationDelegate(self)
        DriveKitTripAnalysis.shared.removeTripListener(self)
        DriveKit.shared.removeDeviceConfigurationDelegate(self)
        NotificationManager.removeNotifications([
            .tripStarted(
                canPostpone: DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip
            ),
            .noNetwork,
            .tripAnalysisError(.missingBeacon),
            .tripAnalysisError(.duplicateTrip),
            .tripAnalysisError(.invalidUser),
            .tripEnded(message: "", transportationMode: .car, hasAdvices: false),
            .tripEnded(message: "", transportationMode: .car, hasAdvices: true),
            .tripCancelled(reason: .noGpsPoint),
            .tripTooShort,
            .criticalDeviceConfiguration(.none)
        ])
    }

    private static func updateDeviceConfigurationNotification() {
        let notificationInfo: DKDiagnosisNotificationInfo?
        if DriveKit.shared.isUserConnected(), 
            DriveKitConfig.isTripAnalysisAutoStartEnabled(),
            AppNavigationController.alreadyOnboarded {
            notificationInfo = DriveKitPermissionsUtilsUI.shared.getDeviceConfigurationEventNotification()
        } else {
            notificationInfo = nil
        }
        if let notificationInfo = notificationInfo {
            self.sendNotification(.criticalDeviceConfiguration(notificationInfo))
        } else {
            self.removeNotification(.criticalDeviceConfiguration(.none))
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier: // User did dismiss a notification action.
                completionHandler()
            case UNNotificationDefaultActionIdentifier: // User did tap a notification action.
                let content = response.notification.request.content
                userDidTapNotification(content: content, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.tenMinutes).identifier:
                deactivateTripAnalysis(during: .tenMinutes, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.thirtyMinutes).identifier:
                deactivateTripAnalysis(during: .thirtyMinutes, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.oneHour).identifier:
                deactivateTripAnalysis(during: .oneHour, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.twoHours).identifier:
                deactivateTripAnalysis(during: .twoHours, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.fourHours).identifier:
                deactivateTripAnalysis(during: .fourHours, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.analyze.identifier:
                completionHandler()
            default:
                completionHandler()
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Used to display notifications while the app is in foreground.
        if #available(iOS 14, *) {
            completionHandler([.list, .banner])
        } else {
            completionHandler(.alert)
        }
    }

    private func userDidTapNotification(content: UNNotificationContent, completionHandler: @escaping () -> Void) {
        let categoryIdentifier = content.categoryIdentifier
        switch categoryIdentifier {
            case NotificationCategory.TripAnalysis.start.identifier:
                if DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip {
                    showDashboardWithTripRecordingButton()
                }
            case NotificationCategory.TripAnalysis.end.identifier:
                if let itineraryId = content.userInfo["itineraryId"] as? String {
                    let hasAdvices = content.userInfo["hasAdvices"] as? Bool ?? false
                    showTrip(with: itineraryId, hasAdvices: hasAdvices)
                }
            case NotificationCategory.deviceConfiguration:
                showDiagnosis()
            default:
                break
        }
        completionHandler()
    }

    private func deactivateTripAnalysis(during duration: TripAnalysisPostponeDuration, completionHandler: @escaping () -> Void) {
        DriveKitTripAnalysis.shared.temporaryDeactivateSDK(minutes: duration.rawValue)
        completionHandler()
    }
    
    func showDashboardWithTripRecordingButton() {
        if let appDelegate = UIApplication.shared.delegate,
           let appNavigationController = appDelegate.window??.rootViewController as? AppNavigationController {
            appNavigationController.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let dashboardVC = appNavigationController.viewControllers.first as? DashboardViewController {
                    dashboardVC.showTripStopConfirmationDialog()
                }
            }
        }
    }
    
    func showTrip(with identifier: String, hasAdvices: Bool) {
        if let appDelegate = UIApplication.shared.delegate, 
            let rootViewController = appDelegate.window??.rootViewController,
            let trip = DriveKitDBTripAccess.shared.find(itinId: identifier) {
            let transportationMode: TransportationMode = TransportationMode(rawValue: Int(trip.transportationMode)) ?? .unknown
            let isAlternative = transportationMode.isAlternative()
            let showAdvice = !isAlternative && hasAdvices
            let detailVC = DriveKitDriverDataUI.shared.getTripDetailViewController(itinId: identifier, showAdvice: showAdvice, alternativeTransport: isAlternative)
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.configure()
            rootViewController.present(navigationController, animated: true)
        }
    }

    func showDiagnosis() {
        if let appDelegate = UIApplication.shared.delegate,
           let appNavigationController = appDelegate.window??.rootViewController as? AppNavigationController {
            let diagnosisViewController = DriveKitPermissionsUtilsUI.shared.getDiagnosisViewController()
            let navigationController = UINavigationController(rootViewController: diagnosisViewController)
            navigationController.configure()
            appNavigationController.present(navigationController, animated: true)
        }
    }
}

extension NotificationManager: TripListener {
    private func sendNotification(_ notificationType: NotificationType, itinId: String? = nil) {
        removeNotifications(before: notificationType)
        let hasAdvices: Bool
        switch notificationType {
            case .tripEnded(_, _, let tripHasAdvices):
                hasAdvices = tripHasAdvices
            default:
                hasAdvices = false
        }
        let userInfo: [String: Any]?
        if let itinId = itinId {
            userInfo = [
                "itineraryId": itinId,
                "hasAdvices": hasAdvices
            ]
        } else {
            userInfo = nil
        }
        NotificationManager.sendNotification(notificationType, userInfo: userInfo)
    }

    private func removeNotifications(before notification: NotificationType) {
        switch notification {
            case .tripStarted:
                // Nothing to remove.
                break
            case .tripEnded, .tripAnalysisError, .noNetwork:
                NotificationManager.removeNotifications([
                    .tripStarted(
                        canPostpone: DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip
                    ),
                    .noNetwork
                ])
            case .tripCancelled, .tripTooShort:
                NotificationManager.removeNotification(
                    .tripStarted(
                        canPostpone: DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip
                    )
                )
            case .criticalDeviceConfiguration:
                // Nothing to remove.
                break
        }
    }

    private func sendCancelNotification(_ reason: TripCancellationReason) {
        sendNotification(.tripCancelled(reason: reason))
    }

    private func sendErrorNotification(_ error: TripResponseError) {
        if let tripResponseErrorNotification = TripResponseErrorNotification.fromTripResponseError(tripResponseError: error) {
            sendNotification(.tripAnalysisError(tripResponseErrorNotification))
        }
    }

    func tripStarted(startMode: StartMode) {
        sendNotification(.tripStarted(canPostpone: DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip))
    }

    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        
        let responseStatus = DriveKitTripAnalysis.shared.getTripResponseStatus(response)
        switch responseStatus.status {
            case .tripValid:
                responseStatus.info.forEach { info in
                    DriveKitLog.shared.infoLog(tag: "App", message: "Trip response info: \(info.getComment())")
                }
                if responseStatus.hasSafetyAndEcoDrivingScore {
                    manageTripFinishedAndValid(response)
                } else if let itinId = response.itinId {
                    sendNotification(.tripTooShort, itinId: itinId)
                }
            case .tripError:
                guard let error = responseStatus.error else { return }
                DriveKitLog.shared.errorLog(tag: "App", message: "Trip response error: \(String(describing: error))")
                sendErrorNotification(error)
        }
    }

    func tripCancelled(cancelTrip: CancelTrip) {
        switch cancelTrip {
            case .highspeed:
                sendCancelNotification(.highSpeed)
            case .noBeacon:
                sendCancelNotification(.noBeacon)
            case .noBluetoothDevice:
                sendCancelNotification(.noBluetoothDevice)
            case .noGPSData:
                sendCancelNotification(.noGpsPoint)
            case .user, .noSpeed, .missingConfiguration, .reset, .beaconNoSpeed, .bluetoothDeviceNoSpeed:
                NotificationManager.removeNotification(.tripStarted(canPostpone: DriveKitTripAnalysisUI.shared.isUserAllowedToCancelTrip))
            @unknown default:
                break
        }
    }

    func tripSavedForRepost() {
        sendNotification(.noNetwork)
    }

    private func manageTripFinishedAndValid(_ response: PostGenericResponse) {
        guard let itinId = response.itinId, let distance = response.itineraryStatistics?.distance, distance > 0 else {
            return
        }
        let transportationMode: TransportationMode
        if let rawTransporationMode = response.itineraryStatistics?.transportationMode {
            transportationMode = TransportationMode(rawValue: rawTransporationMode) ?? .unknown
        } else {
            transportationMode = .unknown
        }
        let message: String?
        let hasAdvices: Bool
        if transportationMode.isAlternative() && transportationMode.isAlternativeNotificationManaged {
            message = nil
            hasAdvices = false
        } else {
            if let tripAdvicesData: [TripAdviceData] = response.tripAdvicesData {
                let adviceString: String
                if tripAdvicesData.count > 1 {
                    adviceString = "notif_trip_finished_advices".keyLocalized()
                } else {
                    adviceString = "notif_trip_finished_advice".keyLocalized()
                }
                message = "\("notif_trip_finished".keyLocalized())\n\(adviceString)"
                hasAdvices = !tripAdvicesData.isEmpty
            } else {
                var messagePart2: String?
                switch DriveKitDriverDataUI.shared.tripData {
                    case .safety:
                        if let safetyScore = response.safety?.safetyScore {
                            messagePart2 = "\("notif_trip_finished_safety".keyLocalized()) : \(safetyScore.formatDouble(places: 1))/10"
                        }
                    case .ecoDriving:
                        if let ecoDrivingScore = response.ecoDriving?.score {
                            messagePart2 = "\("notif_trip_finished_efficiency".keyLocalized()) : \(ecoDrivingScore.formatDouble(places: 1))/10"
                        }
                    case .distraction:
                        if let distractionScore = response.driverDistraction?.score {
                            messagePart2 = "\("notif_trip_finished_distraction".keyLocalized()) : \(distractionScore.formatDouble(places: 1))/10"
                        }
                    case .speeding:
                        break
                    case .distance:
                        if let itineraryStatistics = response.itineraryStatistics {
                            let distance = Int(ceil(itineraryStatistics.distance / 1_000.0))
                            messagePart2 = "\(DKCommonLocalizable.distance.text()) : \(distance) \(DKCommonLocalizable.unitKilometer.text())"
                        }
                    case .duration:
                        if let itineraryStatistics = response.itineraryStatistics {
                            let duration = Int(ceil(itineraryStatistics.tripDuration / 60))
                            messagePart2 = "\(DKCommonLocalizable.duration.text()) : \(duration) \(DKCommonLocalizable.unitMinute.text())"
                        }
                }
                hasAdvices = false
                if let messagePart2 = messagePart2 {
                    message = "\("notif_trip_finished".keyLocalized())\n\(messagePart2)"
                } else {
                    message = "notif_trip_finished".keyLocalized()
                }
            }
        }
        sendNotification(.tripEnded(message: message, transportationMode: transportationMode, hasAdvices: hasAdvices), itinId: itinId)
    }
    
    private enum PostGenericResponseError: Int {
        case unknown = -1
        case noError = 0
        case noApiKey = 21
        case noBeaconDetected = 29
        case invalidBeaconDetected = 30
        case duplicateTrip = 31
    }
}

extension NotificationManager: DKDeviceConfigurationDelegate {
    func deviceConfigurationDidChange(event: DKDeviceConfigurationEvent) {
        NotificationManager.updateDeviceConfigurationNotification()
    }
}

extension TransportationMode {
    var isAlternativeNotificationManaged: Bool {
        switch self {
            case .unknown, .car, .moto, .truck, .flight, .onFoot, .other:
                return false
            case .train, .bus, .boat, .bike, .skiing, .idle:
                return true
            @unknown default:
                return false
        }
    }
}
