//
//  NotificationManager.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataUI
import DriveKitTripAnalysisModule

class NotificationManager: NSObject {
    private static let shared = NotificationManager()
    private static let delay = 2.0

    private override init() {
        super.init()
        DriveKit.shared.registerNotificationDelegate(self)
        TripListenerManager.shared.addTripListener(self)
    }

    static func configure() {
        NotificationManager.shared.configure()
        requestNotificationPermission()
        configureNotifications()
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

    private func configure() {

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
        if let appDelegate = UIApplication.shared.delegate, let rootViewController = appDelegate.window??.rootViewController, let trip = DriveKitDBTripAccess.shared.find(itinId: identifier) {
            let transportationMode: TransportationMode = TransportationMode(rawValue: Int(trip.transportationMode)) ?? .unknown
            let isAlternative = transportationMode.isAlternative()
            let showAdvice: Bool
            if !isAlternative {
                if let advices = trip.tripAdvices, advices.count > 0 {
                    showAdvice = true
                } else {
                    showAdvice = false
                }
            } else {
                showAdvice = false
            }
            let detailVC = DriveKitDriverDataUI.shared.getTripDetailViewController(itinId: identifier, showAdvice: showAdvice, alternativeTransport: isAlternative)
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.configure()
            rootViewController.present(navigationController, animated: true)
        }
    }
}

extension NotificationManager: TripListener {
    private func sendNotification(_ notificationType: NotificationType, itinId: String? = nil) {
        removeNotifications(before: notificationType)
        let userInfo: [String: String]?
        if let itinId = itinId {
            userInfo = ["itineraryId": itinId]
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
            case .tripEnded, .tripAnalysisError:
                NotificationManager.removeNotifications([
                    .tripStarted(canPostpone: DriveKitConfig.isAutoStartPostponable),
                    .tripAnalysisError(.noNetwork)
                ])
            case .tripCancelled, .tripTooShort:
                NotificationManager.removeNotification(.tripStarted(canPostpone: DriveKitConfig.isAutoStartPostponable))
        }
    }

    private func sendCancelNotification(_ reason: TripCancellationReason) {
        sendNotification(.tripCancelled(reason: reason))
    }

    private func sendErrorNotification(_ error: TripAnalysisError) {
        sendNotification(.tripAnalysisError(error))
    }

    func tripStarted(startMode: StartMode) {
        sendNotification(.tripStarted(canPostpone: DriveKitConfig.isAutoStartPostponable))
    }

    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        let errorCodes: Set<PostGenericResponseError>
        if let comments = response.comments {
            errorCodes = Set(comments.map({ PostGenericResponseError(rawValue: $0.errorCode) ?? .unknown }))
        } else {
            errorCodes = []
        }
        if errorCodes.contains(PostGenericResponseError.noApiKey) {
            sendErrorNotification(.noApiKey)
        } else if errorCodes.contains(PostGenericResponseError.noBeaconDetected) || errorCodes.contains(PostGenericResponseError.invalidBeaconDetected) {
            sendErrorNotification(.noBeacon)
        } else if errorCodes.contains(PostGenericResponseError.duplicateTrip) {
            sendErrorNotification(.duplicateTrip)
        } else if let itinId = response.itinId, let distance = response.itineraryStatistics?.distance, distance > 0 {
            let transportationMode: TransportationMode
            if let rawTransporationMode = response.itineraryStatistics?.transportationMode {
                transportationMode = TransportationMode(rawValue: rawTransporationMode) ?? .unknown
            } else {
                transportationMode = .unknown
            }
            let message: String?
            let partialScoredTrip: Bool
            if transportationMode.isAlternative() {
                message = nil
                partialScoredTrip = false
            } else {
                if let tripAdvicesData: [TripAdviceData] = response.tripAdvicesData {
                    let adviceString: String
                    if tripAdvicesData.count > 1 {
                        adviceString = "notif_trip_finished_advices".keyLocalized()
                    } else {
                        adviceString = "notif_trip_finished_advice".keyLocalized()
                    }
                    message = "\("notif_trip_finished".keyLocalized())\n\(adviceString)"
                    partialScoredTrip = false
                } else {
                    var messagePart2: String? = nil
                    switch DriveKitConfig.tripData {
                        case .safety:
                            let safetyScore = response.safety?.safetyScore ?? 11
                            partialScoredTrip = safetyScore > 10
                            if !partialScoredTrip {
                                messagePart2 = "\("notif_trip_finished_safety".keyLocalized()) : \(safetyScore.formatDouble(places: 1))/10"
                            }
                        case .ecoDriving:
                            let ecoDrivingScore = response.ecoDriving?.score ?? 11
                            partialScoredTrip = ecoDrivingScore > 10
                            if !partialScoredTrip {
                                messagePart2 = "\("notif_trip_finished_efficiency".keyLocalized()) : \(ecoDrivingScore.formatDouble(places: 1))/10"
                            }
                        case .distraction:
                            let distractionScore = response.driverDistraction?.score ?? 11
                            partialScoredTrip = distractionScore > 10
                            if !partialScoredTrip {
                                messagePart2 = "\("notif_trip_finished_distraction".keyLocalized()) : \(distractionScore.formatDouble(places: 1))/10"
                            }
                        case .speeding:
                            partialScoredTrip = false
                        case .distance:
                            if let itineraryStatistics = response.itineraryStatistics {
                                let distance = Int(ceil(itineraryStatistics.distance / 1000.0))
                                messagePart2 = "\(DKCommonLocalizable.distance.text()) : \(distance) \(DKCommonLocalizable.unitKilometer.text())"
                            }
                            partialScoredTrip = false
                        case .duration:
                            if let itineraryStatistics = response.itineraryStatistics {
                                let duration = Int(ceil(itineraryStatistics.tripDuration / 60))
                                messagePart2 = "\(DKCommonLocalizable.duration.text()) : \(duration) \(DKCommonLocalizable.unitMinute.text())"
                            }
                            partialScoredTrip = false
                    }
                    if let messagePart2 = messagePart2 {
                        message = "\("notif_trip_finished".keyLocalized())\n\(messagePart2)"
                    } else {
                        message = "notif_trip_finished".keyLocalized()
                    }
                }
            }
            if partialScoredTrip {
                sendNotification(.tripTooShort, itinId: itinId)
            } else {
                sendNotification(.tripEnded(message: message, transportationMode: transportationMode), itinId: itinId)
            }
        }
    }

    func tripCancelled(cancelTrip: CancelTrip) {
        switch cancelTrip {
            case .highspeed:
                sendCancelNotification(.highSpeed)
            case .noBeacon:
                sendCancelNotification(.noBeacon)
            case .noGPSData:
                sendCancelNotification(.noGpsPoint)
            case .user, .noSpeed, .missingConfiguration, .reset, .beaconNoSpeed:
                NotificationManager.removeNotification(.tripStarted(canPostpone: DriveKitConfig.isAutoStartPostponable))
        }
    }

    func tripSavedForRepost() {
        sendErrorNotification(.noNetwork)
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

    private enum PostGenericResponseError: Int {
        case unknown = -1
        case noError = 0
        case noApiKey = 21
        case noBeaconDetected = 29
        case invalidBeaconDetected = 30
        case duplicateTrip = 31
    }
}
