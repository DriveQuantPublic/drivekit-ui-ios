// swiftlint:disable no_magic_numbers
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

    func isScored(trip: DKTripListItem) -> Bool {
        return trip.isScored(tripData: self)
    }

    func stringValue(trip: DKTripListItem) -> String {
        switch self {
        case .ecoDriving, .safety, .distraction, .speeding:
            return trip.getScore(tripData: self)?.format(maximumFractionDigits: 1) ?? "0"
        case .distance:
            let unit = DriveKitUI.shared.unitSystem == .international
                ? DKCommonLocalizable.unitKilometer.text()
                : DKCommonLocalizable.unitMile.text()
            return trip.getDistance()?.formatMeterDistance() ?? "0 \(unit)"
        case .duration:
            return trip.getDuration().roundUp(step: 60.0).formatSecondDuration()
        }
    }
}

public enum DisplayType {
    case gauge, text
}
