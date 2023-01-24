// swiftlint:disable all
//
//  NotificationAction.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

enum NotificationAction {
    enum TripAnalysis {
        case postpone(TripAnalysisPostponeDuration)
        case analyze

        var identifier: String {
            switch self {
                case .postpone(let duration):
                    return "trip.postpone_\(duration.rawValue)"
                case .analyze:
                    return "trip.analyze"
            }
        }

        var title: String {
            switch self {
                case .postpone(let duration):
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .full
                    formatter.allowedUnits = [.hour, .minute]
                    formatter.zeroFormattingBehavior = .dropAll
                    let result: String
                    if let string = formatter.string(from: Double(duration.rawValue * 60)) {
                        result = "notif_trip_analysis_suspend".keyLocalized() + " " + string
                    } else {
                        result = "notif_trip_analysis_suspend".keyLocalized()
                    }
                    return result
                case .analyze:
                    return "notif_trip_analysis_continue".keyLocalized()
            }
        }
    }
}
