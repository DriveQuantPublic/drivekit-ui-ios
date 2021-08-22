//
//  LastTripsViewModel.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

struct LastTripsViewModel {
    let trips: [DKTripListItem]
    let tripData: TripData
    let headerDay: HeaderDay
    weak var parentViewController: UIViewController?
    weak var delegate: DKLastTripsWidgetDelegate?

    func titleForTrip(_ trip: DKTripListItem) -> String {
        let firstPart: String
        if let formattedDate = trip.getStartDate()?.format(pattern: .weekLetter).capitalizeFirstLetter() {
            firstPart = "\(formattedDate) | "
        } else {
            firstPart = ""
        }
        return firstPart + self.headerDay.text(trips: [Trip(trip: trip)])
    }

    func didSelectTrip(at index: Int) {
        if let delegate = delegate, index >= 0 && index < self.trips.count {
            let trip = self.trips[index]
            delegate.didSelectTrip(trip)
        }
    }
}

private struct Trip : DKTripListItem {
    fileprivate let trip: DKTripListItem

    func getItinId() -> String {
        trip.getItinId()
    }

    func getDuration() -> Double {
        trip.getDuration()
    }

    func getDistance() -> Double? {
        trip.getDistance()
    }

    func getStartDate() -> Date? {
        trip.getStartDate()
    }

    func getEndDate() -> Date {
        trip.getEndDate()
    }

    func getDepartureCity() -> String? {
        trip.getDepartureCity()
    }

    func getArrivalCity() -> String? {
        trip.getArrivalCity()
    }

    func isScored(tripData: TripData) -> Bool {
        trip.isScored(tripData: tripData)
    }

    func getScore(tripData: TripData) -> Double? {
        trip.getScore(tripData: tripData)
    }

    func getTransportationModeImage() -> UIImage? {
        trip.getTransportationModeImage()
    }

    func isAlternative() -> Bool {
        trip.isAlternative()
    }

    func infoText() -> String? {
        trip.infoText()
    }

    func infoImage() -> UIImage? {
        trip.infoImage()
    }

    func infoClickAction(parentViewController: UIViewController) {
        trip.infoClickAction(parentViewController: parentViewController)
    }

    func hasInfoActionConfigured() -> Bool {
        trip.hasInfoActionConfigured()
    }

    func isInfoDisplayable() -> Bool {
        trip.isInfoDisplayable()
    }
}
