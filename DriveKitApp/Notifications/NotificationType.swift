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
    case tripAnalysisError(TripResponseErrorNotification)
    case noNetwork
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
            case .noNetwork:
                identifier = "205"
            case .tripAnalysisError(let tripAnalysisError):
                identifier = tripAnalysisError.identifier
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
            case .noNetwork:
                categoryIdentifier = nil
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
                return error.channel
            case .tripCancelled:
                return .tripCancelled
            case .criticalDeviceConfiguration:
                return .deviceConfiguration
            case .noNetwork:
                return .tripEnded
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
                return ""
            case .tripTooShort:
                key = "notif_trip_too_short_title"
            case .criticalDeviceConfiguration(let notificationInfo):
                return notificationInfo.title
            case .noNetwork:
                key = "notif_trip_no_network_title"
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
                return tripAnalysisError.localizedDescription
            case .tripTooShort:
                key = "notif_trip_too_short"
            case .criticalDeviceConfiguration(let notificationInfo):
                return notificationInfo.body
            case .noNetwork:
                key = "notif_trip_no_network"
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

enum TripResponseErrorNotification {
    case invalidRouteDefintiion
    case invalidSamplingPeriod
    case invalidCustomerId
    case maxDailyRequestNumberReached
    case dataError
    case invalidRouteVectors
    case duplicateTrip
    case insufficientGpsData
    case userDisabled
    case invalidUser
    case invalidGpsData
    case invalidTrip
    case accountLimitReached
    case missingBeacon
    case invalidBeacon

    // swiftlint:disable:next cyclomatic_complexity
    static func fromTripResponseError(tripResponseError: TripResponseError) -> TripResponseErrorNotification? {
        switch tripResponseError {
            case .noAccountSet,
                 .noRouteObjectFound,
                 .invalidRouteDefintiion,
                 .noVelocityData,
                 .noDateFound:
                return nil
            case .invalidSamplingPeriod:
                return .invalidSamplingPeriod
            case .invalidCustomerId:
                return .invalidCustomerId
            case .maxDailyRequestNumberReached:
                return .maxDailyRequestNumberReached
            case .dataError:
                return .dataError
            case .invalidRouteVectors:
                return .invalidRouteVectors
            case .missingBeacon:
                return .missingBeacon
            case .invalidBeacon:
                return .invalidBeacon
            case .duplicateTrip:
                return .duplicateTrip
            case .insufficientGpsData:
                return .insufficientGpsData
            case .userDisabled:
                return .userDisabled
            case .invalidUser:
                return .invalidUser
            case .invalidGpsData:
                return .invalidGpsData
            case .invalidTrip:
                return .invalidTrip
            case .accountLimitReached:
                return .accountLimitReached
        }
    }

    var localizedDescription: String {
        switch self {
            case .invalidRouteDefintiion:
                "dk_trip_service_insufficient_gps_data".dkTripAnalysisLocalized()
            case .invalidSamplingPeriod:
                "dk_trip_service_invalid_sample_period".dkTripAnalysisLocalized()
            case .invalidCustomerId:
                "dk_trip_service_error_invalid_customer_id".dkTripAnalysisLocalized()
            case .maxDailyRequestNumberReached:
                "dk_trip_service_request_limit_reached".dkTripAnalysisLocalized()
            case .dataError:
                "dk_trip_service_analysis_failed".dkTripAnalysisLocalized()
            case .invalidRouteVectors:
                "dk_trip_service_analysis_failed".dkTripAnalysisLocalized()
            case .duplicateTrip:
                "dk_trip_service_error_trip_duplicate".dkTripAnalysisLocalized()
            case .insufficientGpsData:
                "dk_trip_service_insufficient_gps_data".dkTripAnalysisLocalized()
            case .userDisabled:
                "dk_trip_service_user_disabled".dkTripAnalysisLocalized()
            case .invalidUser:
                "dk_trip_service_user_invalid".dkTripAnalysisLocalized()
            case .invalidGpsData:
                "dk_trip_service_invalid_gps_data".dkTripAnalysisLocalized()
            case .invalidTrip:
                "dk_trip_service_invalid_gps_data".dkTripAnalysisLocalized()
            case .accountLimitReached:
                "dk_trip_service_account_limit_reached".dkTripAnalysisLocalized()
            case .missingBeacon:
                "dk_trip_service_error_beacon_missing".dkTripAnalysisLocalized()
            case .invalidBeacon:
                "dk_trip_service_error_beacon_invalid".dkTripAnalysisLocalized()
        }
    }

    var identifier: String {
        switch self {
            case .invalidRouteDefintiion:
                return "208"
            case .invalidSamplingPeriod:
                return "209"
            case .invalidCustomerId:
                return "204"
            case .maxDailyRequestNumberReached:
                return "210"
            case .dataError, .invalidRouteVectors:
                return "211"
            case .duplicateTrip:
                return "203"
            case .insufficientGpsData:
                return "212"
            case .userDisabled:
                return "213"
            case .invalidUser:
                return "214"
            case .invalidGpsData:
                return "215"
            case .invalidTrip:
                return "216"
            case .accountLimitReached:
                return "217"
            case .missingBeacon, .invalidBeacon:
                return "252"
        }
    }

    var channel: NotificationChannel {
        if self == .missingBeacon || self == .invalidBeacon {
            return .tripCancelled
        } else {
            return .tripEnded
        }
    }
}
