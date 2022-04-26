//
//  NotificationCategory.swift
//  DriveKitApp
//
//  Created by David Bauduin on 24/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

enum NotificationCategory {
    enum TripAnalysis {
        case start
        case end
        case noNetworkError

        var identifier: String {
            switch self {
                case .start:
                    return "trip.start"
                case .end:
                    return "trip.end"
                case .noNetworkError:
                    return "trip.noNetworkError"
            }
        }
    }
}
