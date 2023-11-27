//
//  NotificationType.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitTripAnalysisModule
import DriveKitDriverDataUI
import DriveKitPermissionsUtilsUI

enum NotificationType {
    case tripStarted(canPostpone: Bool)
    case tripEnded(message: String?, transportationMode: TransportationMode, hasAdvices: Bool)
    case tripCancelled(reason: TripCancellationReason)
    case tripAnalysisError(TripAnalysisError)
    case tripTooShort
    case criticalDeviceConfiguration(DKDiagnosisNotificationInfo)

    private static let tripEndedError = "300"

    var identifier: String {
        let identifier: String
        switch self {
            case .tripStarted:
                identifier = "100"
            case .tripEnded(_, let transportationMode, let hasAdvices):
                if transportationMode.isAlternative() && transportationMode.isAlternativeNotificationManaged {
                    identifier = NotificationType.tripEndedError
                } else {
                    identifier = hasAdvices ? "201" : "200"
                }
            case .tripCancelled:
                identifier = NotificationType.tripEndedError
            case .tripAnalysisError(let tripAnalysisError):
                switch tripAnalysisError {
                    case .duplicateTrip:
                        identifier = "203"
                    case .noNetwork:
                        identifier = "205"
                    case .noApiKey:
                        identifier = "204"
                    case .noBeacon:
                        identifier = NotificationType.tripEndedError
                }
            case .tripTooShort:
                identifier = "202"
            case .criticalDeviceConfiguration:
                identifier = "500"
        }
        return identifier
    }

    // The category is used to distinguish between the different types of notifications and mainly to add actions to a notification.
    var categoryIdentifier: String? {
        let categoryIdentifier: String?
        switch self {
            case .tripStarted(let canPostpone):
                categoryIdentifier = canPostpone ? NotificationCategory.TripAnalysis.start.identifier : nil
            case .tripEnded(_, let transportationMode, _):
                if transportationMode.isAlternative() {
                    if transportationMode.isAlternativeNotificationManaged && DriveKitDriverDataUI.shared.enableAlternativeTrips {
                        categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
                    } else {
                        categoryIdentifier = nil
                    }
                } else {
                    categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
                }
            case .tripCancelled:
                categoryIdentifier = nil
            case .tripAnalysisError:
                categoryIdentifier = nil
            case .tripTooShort:
                categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
            case .criticalDeviceConfiguration:
                categoryIdentifier = NotificationCategory.deviceConfiguration
        }
        return categoryIdentifier
    }

    var channel: NotificationChannel {
        switch self {
            case .tripStarted:
                return .tripStarted
            case .tripEnded(_, let transportationMode, _):
                if !transportationMode.isAlternative() || !transportationMode.isAlternativeNotificationManaged {
                    return .tripEnded
                } else {
                    if DriveKitDriverDataUI.shared.enableAlternativeTrips {
                        return .tripEnded
                    } else {
                        return .tripCancelled
                    }
                }
            case .tripTooShort:
                return .tripEnded
            case .tripAnalysisError(let error):
                switch error {
                    case .duplicateTrip, .noNetwork, .noApiKey:
                        return .tripEnded
                    case .noBeacon:
                        return .tripCancelled
                }
            case .tripCancelled:
                return .tripCancelled
            case .criticalDeviceConfiguration:
                return .deviceConfiguration
        }
    }

    var title: String {
        let key: String
        switch self {
            case .tripStarted:
                key = "notif_trip_started_title"
            case .tripEnded:
                key = "notif_trip_finished_title"
            case .tripCancelled(let reason):
                switch reason {
                    case .noBeacon, .noBluetoothDevice, .highSpeed:
                        key = "notif_trip_cancelled_title"
                    case .noGpsPoint:
                        key = "notif_trip_cancelled_no_gps_data_title"
                }
            case .tripAnalysisError(let tripAnalysisError):
                switch tripAnalysisError {
                    case .duplicateTrip, .noApiKey, .noBeacon:
                        return ""
                    case .noNetwork:
                        key = "notif_trip_no_network_title"
                }
            case .tripTooShort:
                key = "notif_trip_too_short_title"
            case .criticalDeviceConfiguration(let notificationInfo):
                return notificationInfo.title
        }
        return key.keyLocalized()
    }

    var body: String {
        let key: String
        switch self {
            case .tripStarted(let canPostpone):
                if canPostpone {
                    return "\("notif_trip_started".keyLocalized())\n\("notif_trip_postpone".keyLocalized())"
                } else {
                    key = "notif_trip_started"
                }
            case .tripEnded(let message, let transportationMode, _):
                if !transportationMode.isAlternative() {
                    return message ?? ""
                } else {
                    let areAlternativeTripsManaged = DriveKitDriverDataUI.shared.enableAlternativeTrips
                    switch transportationMode {
                        case .train:
                            key = areAlternativeTripsManaged ? "notif_trip_train_detected" : "notif_trip_train_detected_not_displayed"
                        case .bus:
                            key = areAlternativeTripsManaged ? "notif_trip_bus_detected" : "notif_trip_bus_detected_not_displayed"
                        case .boat:
                            key = areAlternativeTripsManaged ? "notif_trip_boat_detected" : "notif_trip_boat_detected_not_displayed"
                        case .bike:
                            key = areAlternativeTripsManaged ? "notif_trip_bike_detected" : "notif_trip_bike_detected_not_displayed"
                        case .skiing:
                            key = areAlternativeTripsManaged ? "notif_trip_skiing_detected" : "notif_trip_skiing_detected_not_displayed"
                        case .idle:
                            key = areAlternativeTripsManaged ? "notif_trip_idle_detected" : "notif_trip_idle_detected_not_displayed"
                        case .car, .unknown, .truck, .moto, .flight, .onFoot, .other:
                            return ""
                        @unknown default:
                            return ""
                    }
                }
            case .tripCancelled(let reason):
                switch reason {
                    case .noBeacon:
                        key = "notif_trip_cancelled_no_beacon"
                    case .noBluetoothDevice:
                        key = "notif_trip_cancelled_no_bluetooth_device"
                    case .highSpeed:
                        key = "notif_trip_cancelled_highspeed"
                    case .noGpsPoint:
                        key = "notif_trip_cancelled_no_gps_data"
                }
            case .tripAnalysisError(let tripAnalysisError):
                switch tripAnalysisError {
                    case .duplicateTrip:
                        key = "notif_trip_error_duplicate_trip"
                    case .noNetwork:
                        key = "notif_trip_no_network"
                    case .noApiKey:
                        key = "notif_trip_error_unauthorized"
                    case .noBeacon:
                        key = "notif_trip_finished_no_beacon"
                }
            case .tripTooShort:
                key = "notif_trip_too_short"
            case .criticalDeviceConfiguration(let notificationInfo):
                return notificationInfo.body
        }
        return key.keyLocalized()
    }
}

enum TripCancellationReason {
    case noBeacon
    case noBluetoothDevice
    case highSpeed
    case noGpsPoint
}

enum TripAnalysisError {
    case duplicateTrip
    case noNetwork
    case noApiKey
    case noBeacon
}
