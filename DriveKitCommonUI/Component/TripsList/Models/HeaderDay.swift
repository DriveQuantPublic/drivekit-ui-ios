//
//  HeaderDay.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation

public enum HeaderDay {
    case distance, duration, distanceDuration, durationDistance, none
    
    public func text<TripsListItem: DKTripListItem>(trips: [TripsListItem]) -> String {
        switch self {
            case .distance:
                return trips.totalDistance.formatMeterDistanceInKm()
            case .duration:
                return trips.totalRoundedDuration.formatSecondDuration()
            case .distanceDuration:
                return  trips.totalDistance.formatMeterDistanceInKm() + " | " + trips.totalRoundedDuration.formatSecondDuration()
            case .durationDistance:
                return  trips.totalRoundedDuration.formatSecondDuration() + " | " + trips.totalDistance.formatMeterDistanceInKm()
            case .none:
                return ""
        }
    }
}
