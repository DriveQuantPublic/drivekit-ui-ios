//
//  NotificationManager.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import DriveKitTripAnalysisModule

class NotificationManager: NSObject {
    private static let shared = NotificationManager()
    private static let delay = 2.0
    private var initialized = false

    private override init() {}

    static func configure() {
        requestNotificationPermission()
        configureNotifications()
        if !shared.initialized {
            shared.initialized = true
            TripListenerManager.shared.addTripListener(shared)
        }
    }

    static func sendNotification(_ notification: NotificationType, userInfo: [String: String]? = nil) {
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

            UNUserNotificationCenter.current().add(request) { error in
            }
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
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    private static func configureNotifications() {
        let actionList: [NotificationAction.TripAnalysis] = [.postpone(.fifteenMinutes), .postpone(.thirtyMinutes), .postpone(.oneHour), .postpone(.twoHours), .analyze]
        let notificationActions = actionList.map {
            UNNotificationAction(identifier: $0.identifier,
                                 title: $0.title,
                                 options: [])
        }
        let notificationCategory = UNNotificationCategory(identifier: NotificationCategory.TripAnalysis.start.identifier,
                                              actions: notificationActions,
                                              intentIdentifiers: [],
                                              options: [])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([notificationCategory])
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
            case NotificationAction.TripAnalysis.postpone(.fifteenMinutes).identifier:
                deactivateTripAnalysis(during: .fifteenMinutes, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.thirtyMinutes).identifier:
                deactivateTripAnalysis(during: .thirtyMinutes, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.oneHour).identifier:
                deactivateTripAnalysis(during: .oneHour, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.postpone(.twoHours).identifier:
                deactivateTripAnalysis(during: .twoHours, completionHandler: completionHandler)
            case NotificationAction.TripAnalysis.analyze.identifier:
                completionHandler()
            default:
                completionHandler()
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        #warning("TODO: Delete previous notifications")
        completionHandler(UNNotificationPresentationOptions.alert)
    }

    private func userDidTapNotification(content: UNNotificationContent, completionHandler: @escaping () -> Void) {
        let categoryIdentifier = content.categoryIdentifier
        switch categoryIdentifier {
            case NotificationCategory.TripAnalysis.start.identifier:
                break
            case NotificationCategory.TripAnalysis.end.identifier:
                if let itineraryId = content.userInfo["itineraryId"] as? String {
                    showTrip(with: itineraryId)
                }
            default:
                break
        }
        completionHandler()
    }

    private func deactivateTripAnalysis(during duration: TripAnalysisPostponeDuration, completionHandler: @escaping () -> Void) {
        DriveKitTripAnalysis.shared.temporaryDeactivateSDK(minutes: duration.rawValue)
        completionHandler()
    }

    func showTrip(with identifier: String) {
        #warning("TODO")
//        guard let controller = self.window?.rootViewController, let trip = TMService.trips.trip(with: identifier), let itinId = trip.itinId else {
//            return
//        }
//        let alternative = TripListStatus.init(rawValue: Int(trip.transportationMode))?.isAlternativeTransportationMode() ?? false
//        let showAdvice: Bool
//        if !alternative {
//            if let advices = trip.advices, !advices.isEmpty {
//                showAdvice = true
//            } else {
//                showAdvice = false
//            }
//        } else {
//            showAdvice = false
//        }
//        let detailVC = DriveKitDriverDataUI.shared.getTripDetailViewController(itinId: itinId, showAdvice: showAdvice, alternativeTransport: alternative)
//        let navigationController = UINavigationController(rootViewController: detailVC)
//        navigationController.customize(.branded)
//        controller.present(navigationController, animated: true)
    }
}

extension NotificationManager: TripListener {
    func tripStarted(startMode: StartMode) {
        //TODO: sendNotification(.tripStarted(DQConfiguration.shared.app_auto_start_postponable))
    }

    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        //TODO
//        if let route = post.route, let itineraryData = response.itineraryData{
//            tripReceived(response: response, route: route, itineraryData: itineraryData)
//        }
    }

    func tripCancelled(cancelTrip: CancelTrip) {
        //TODO
//        switch cancelTrip {
//            case .highspeed: // highSpeed
//                sendNotification(.cancelHighSpeed)
//            case .noBeacon: // no beacon
//                sendNotification(.cancelNoBeacon)
//            case .noGPSData:
//                sendNotification(.noGPSPoint)
//            default:
//                // other cancel reasons : 0 -> user, 1 -> speed not confirmed
//                return
//        }
    }

    func tripSavedForRepost() {
        //TODO: sendNotification(.noNetwork)
    }

    func tripPoint(tripPoint: TripPoint) {
        // Nothing to do
    }

    func beaconDetected() {
        // Nothing to do.
    }

    func significantLocationChangeDetected(location: CLLocation) {
        // Nothing to do.
    }

    func sdkStateChanged(state: State) {
        // Nothing to do.
    }

    func potentialTripStart(startMode: StartMode) {
        // Nothing to do.
    }

    func crashDetected(crashInfo: DKCrashInfo) {
        // Nothing to do.
    }

    func crashFeedbackSent(crashInfo: DKCrashInfo, feedbackType: DKCrashFeedbackType, severity: DKCrashFeedbackSeverity) {
        // Nothing to do.
    }
}
