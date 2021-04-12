//
//  TripData.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 07/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public enum TripData: String {
    case ecoDriving, safety, distraction, distance, duration, speeding

    public func displayType() -> DisplayType {
        switch self {
        case .ecoDriving, .safety, .distraction, .speeding:
            return .gauge
        case .duration, .distance:
            return .text
        }
    }

    func isScored(trip: DKTripsListItem) -> Bool {
        return trip.isScored(tripData: self)
    }

    func stringValue(trip: DKTripsListItem) -> String {
        switch self {
        case .ecoDriving, .safety, .distraction, .speeding:
            return String(format: "%.1f", trip.getScore(tripData: self) ?? 0)
        case .distance:
            return trip.getDistance()?.formatMeterDistanceInKm() ?? "0 \(DKCommonLocalizable.unitKilometer.text())"
        case .duration:
            return trip.getDuration().roundUp(step: 60.0).formatSecondDuration()
        }
    }

}

public enum DisplayType {
    case gauge, text
}
