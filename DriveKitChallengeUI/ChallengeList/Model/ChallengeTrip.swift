// swiftlint:disable all
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
import UIKit

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
    public func getDepartureAddress() -> String? {
        return trip.departureAddress
    }
    public func getArrivalCity() -> String? {
        return trip.arrivalCity
    }
    public func getArrivalAddress() -> String? {
        return trip.arrivalAddress
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
        guard let transportationMode = TransportationMode(rawValue: Int(trip.transportationMode)) else {
            return true
        }
        switch transportationMode {
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
                return false
        }
    }

    public func infoText() -> String? {
        guard let tripAdvices: Set<TripAdvice> = trip.tripAdvices as? Set<TripAdvice> else {
            return nil
        }
        if tripAdvices.count > 1 {
            return "\(tripAdvices.count)"
        } else {
            return nil
        }
    }

    public func infoImage() -> UIImage? {
        guard let tripAdvices: [TripAdvice] = trip.tripAdvices?.allObjects as? [TripAdvice] else {
            return nil
        }
        if tripAdvices.count > 1 {
            return DKImages.tripInfoCount.image
        } else if tripAdvices.count == 1 {
            let advice = tripAdvices[0]
            if advice.theme == "SAFETY" {
                return DKImages.safetyAdvice.image
            } else if advice.theme == "ECODRIVING" {
                return DKImages.ecoAdvice.image
            }
        }
        return nil
    }

    public func infoClickAction(parentViewController: UIViewController) {
        let showAdvice = (trip.tripAdvices as? Set<TripAdvice>)?.count ?? 0 > 0
        if let tripId = trip.itinId {
            if let challengeTripsVC: ChallengeTripsVC = parentViewController.parent as? ChallengeTripsVC {
                challengeTripsVC.didSelectTrip(itinId: tripId, showAdvice: showAdvice)
            }
        }
    }

    public func hasInfoActionConfigured() -> Bool {
        return true
    }

    public func isInfoDisplayable() -> Bool {
        guard let tripAdvices: Set<TripAdvice> = trip.tripAdvices as? Set<TripAdvice> else {
            return false
        }
        return tripAdvices.count > 0
    }
}
