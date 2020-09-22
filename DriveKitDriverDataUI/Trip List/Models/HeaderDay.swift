//
//  HeaderDay.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

public enum HeaderDay {
    case distance, duration, distanceDuration
    
    func text(trips: [Trip]) -> String {
        switch self {
        case .distance:
            return trips.totalDistance.formatMeterDistanceInKm()
        case .duration:
            return trips.totalDuration.formatSecondDuration()
        case .distanceDuration:
            return  trips.totalDistance.formatMeterDistanceInKm() + " | " +  trips.totalDuration.formatSecondDuration()
        }
    }
}
