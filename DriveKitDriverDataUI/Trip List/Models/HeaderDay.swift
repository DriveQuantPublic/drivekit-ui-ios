//
//  HeaderDay.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData

public enum HeaderDay {
    case distance, duration, distanceDuration
    
    func text(trips: [Trip]) -> String {
        switch self {
        case .distance:
            return trips.totalDistance.formattedDistance
        case .duration:
            return trips.totalDuration.formattedDuration
        case .distanceDuration:
            return trips.totalDuration.formattedDuration + " | " + trips.totalDistance.formattedDistance
        }
    }
}
