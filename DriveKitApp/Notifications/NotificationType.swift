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

enum NotificationType {
    case tripStarted(canPostpone: Bool)
    case tripEnded(message: String?, transportationMode: TransportationMode, itinId: String)
    case tripCancelled(reason: TripCancellationReason)
    case tripAnalysisError(TripAnalysisError)
    case tripTooShort

    var identifier: String {
        let identifier: String
        switch self {
            case .tripStarted:
                identifier = "trip.started"
            case .tripEnded:
                identifier = "trip.ended"
            case .tripCancelled:
                identifier = "trip.cancelled"
            case .tripAnalysisError:
                identifier = "trip.error"
            case .tripTooShort:
                identifier = "trip.tooShort"
        }
        return identifier
    }

    var categoryIdentifier: String? {
        let categoryIdentifier: String?
        switch self {
            case .tripStarted:
                categoryIdentifier = NotificationCategory.TripAnalysis.start.identifier
            case .tripEnded(_, let transportationMode, _):
                if transportationMode.isAlternative() {
                    if DriveKitDriverDataUI.shared.enableAlternativeTrips {
                        categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
                    } else {
                        categoryIdentifier = nil
                    }
                } else {
                    categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
                }
            case .tripCancelled:
                categoryIdentifier = nil
            case .tripAnalysisError(let tripAnalysisError):
                if tripAnalysisError == .noNetwork {
                    categoryIdentifier = NotificationCategory.TripAnalysis.noNetworkError.identifier
                } else {
                    categoryIdentifier = nil
                }
            case .tripTooShort:
                categoryIdentifier = NotificationCategory.TripAnalysis.end.identifier
        }
        return categoryIdentifier
    }

    var channel: NotificationChannel {
        switch self {
            case .tripStarted:
                return .tripStarted
            case .tripEnded(_, let transportationMode, _):
                if transportationMode.isAlternative() && DriveKitDriverDataUI.shared.enableAlternativeTrips {
                    return .tripEnded
                } else {
                    return .tripCancelled
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
                    case .noBeacon, .highSpeed:
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
                switch transportationMode {
                    case .car:
                        return message ?? ""
                    case .train:
                        key = "notif_trip_train_detected"
                    case .boat:
                        key = "notif_trip_boat_detected"
                    case .bike:
                        key = "notif_trip_bike_detected"
                    case .skiing:
                        key = "notif_trip_skiing_detected"
                    case .idle:
                        key = "notif_trip_idle_detected"
                    case .unknown, .moto, .truck, .bus, .flight, .onFoot, .other:
                        return ""
                }
            case .tripCancelled(let reason):
                switch reason {
                    case .noBeacon:
                        key = "notif_trip_cancelled_no_beacon"
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
        }
        return key.keyLocalized()
    }
}

enum NotificationChannel {
    case tripStarted
    case tripCancelled
    case tripEnded

    var isEnabled: Bool {
        #warning("TODO")
        return true
    }
}

enum TripCancellationReason {
    case noBeacon
    case highSpeed
    case noGpsPoint
}

enum TripAnalysisError {
    case duplicateTrip
    case noNetwork
    case noApiKey
    case noBeacon
}

extension TransportationMode {
    func isAlternative() -> Bool {
        switch self {
            case .unknown,
                    .car,
                    .moto,
                    .truck:
                return false
            case .bus,
                    .train,
                    .boat,
                    .bike,
                    .flight,
                    .skiing,
                    .onFoot,
                    .idle,
                    .other:
                return true
            @unknown default:
                return true
        }
    }
}
