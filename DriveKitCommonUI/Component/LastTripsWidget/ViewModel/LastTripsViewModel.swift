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
        if index >= 0 && index < self.trips.count {
            let trip = self.trips[index]
            didSelectTrip(trip)
        }
    }

    func didSelectInfoView(of tripItem: DKTripListItem) {
        if tripItem.hasInfoActionConfigured() {
            if let parentViewController = self.parentViewController {
                tripItem.infoClickAction(parentViewController: parentViewController)
            } else {
                didSelectTrip(tripItem, showAdvice: true)
            }
        } else {
            didSelectTrip(tripItem)
        }
    }

    func didSelectAllTrips() {
        if self.parentViewController != nil, let tripList = DriveKitNavigationController.shared.driverDataUI?.getTripListViewController() {
            showViewController(tripList)
        }
    }

    private func didSelectTrip(_ trip: DKTripListItem, showAdvice: Bool = false) {
        if self.parentViewController != nil, 
            let tripDetail = DriveKitNavigationController.shared.driverDataUI?
            .getTripDetailViewController(itinId: trip.getItinId(), showAdvice: showAdvice, alternativeTransport: false) {
            showViewController(tripDetail)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": trip.getItinId()])
        }
    }

    private func showViewController(_ viewController: UIViewController) {
        if let parentViewController = self.parentViewController {
            if let navigationController = parentViewController.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                parentViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

private struct Trip: DKTripListItem {
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

    func getDepartureAddress() -> String? {
        trip.getDepartureAddress()
    }

    func getArrivalCity() -> String? {
        trip.getArrivalCity()
    }

    func getArrivalAddress() -> String? {
        trip.getArrivalAddress()
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
