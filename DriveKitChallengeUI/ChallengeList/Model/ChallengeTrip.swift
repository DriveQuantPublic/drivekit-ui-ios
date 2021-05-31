//
//  ChallengeTrip.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 31/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitCommonUI

struct ChallengeTrip: DKTripListItem {
    let trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    public func getItinId() -> String {
        return trip.itinId ?? ""
    }
    public func getDuration() -> Double {
        return Double(trip.tripStatistics?.duration ?? 0)
    }
    public func getDistance() -> Double? {
        return trip.tripStatistics?.distance
    }
    public func getStartDate() -> Date? {
        return trip.startDate
    }
    public func getEndDate() -> Date {
        return trip.endDate ?? Date()
    }
    public func getDepartureCity() -> String? {
        return trip.departureCity
    }
    public func getArrivalCity() -> String? {
        return trip.arrivalCity
    }

    public func isScored(tripData: TripData) -> Bool {
        switch tripData {
        case .safety, .ecoDriving:
            return !trip.unscored
        case .distraction:
            if !trip.unscored, let score = trip.driverDistraction?.score {
                return score <= 10
            }
            return false
        case .speeding:
            if !trip.unscored, let score = trip.speedingStatistics?.score {
                return score <= 10
            }
            return false
        case .distance, .duration:
            return true
        }
    }

    public func getScore(tripData: TripData) -> Double? {
        switch tripData {
        case .ecoDriving:
            return trip.ecoDriving?.score ?? 0
        case .safety:
            return  trip.safety?.safetyScore ?? 0
        case .distraction:
            return trip.driverDistraction?.score ?? 0
        case .speeding:
            return trip.speedingStatistics?.score ?? 0
        case .distance:
            return self.getDistance()
        case .duration:
            return self.getDuration()
        }
    }

    public func getTransportationModeImage() -> UIImage? {
        return nil
    }

    public func isAlternative() -> Bool {
        return TransportationMode(rawValue: Int(trip.transportationMode)) != TransportationMode.car
    }

    public func infoText() -> String? {
        return nil
    }

    public func infoImage() -> UIImage? {
        return nil
    }

    public func infoClickAction(parentViewController: UIViewController) {
    }
    func hasInfoActionConfigured() -> Bool {
        return false
    }

    func isInfoDisplayable() -> Bool {
        return false
    }
}
