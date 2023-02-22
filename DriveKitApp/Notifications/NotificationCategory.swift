// swiftlint:disable all
//
//  NotificationCategory.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

/**
 Used to distinguish between the different types of notifications and primarily to create actionable notifications with custom action buttons.
 */
enum NotificationCategory {
    enum TripAnalysis {
        case start
        case end

        var identifier: String {
            switch self {
                case .start:
                    return "trip.start"
                case .end:
                    return "trip.end"
            }
        }
    }
}
