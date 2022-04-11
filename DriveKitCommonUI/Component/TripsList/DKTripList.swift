//
//  DKTripList.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCoreModule

public protocol DKTripListItem {
    func getItinId() -> String
    func getDuration() -> Double
    func getDistance() -> Double?
    func getStartDate() -> Date?
    func getEndDate() -> Date
    func getDepartureCity() -> String?
    func getDepartureAddress() -> String?
    func getArrivalCity() -> String?
    func getArrivalAddress() -> String?
    func isScored(tripData: TripData) -> Bool
    func getScore(tripData: TripData) -> Double?
    func getTransportationModeImage() -> UIImage?
    func isAlternative() -> Bool
    func infoText() -> String?
    func infoImage() -> UIImage?
    func infoClickAction(parentViewController: UIViewController)
    func hasInfoActionConfigured() -> Bool
    func isInfoDisplayable() -> Bool
}

public protocol DKTripList: AnyObject {
    func didSelectTrip(itinId: String)
    func getTripData() -> TripData
    func getTripsList() -> [DKTripsByDate]
    func getCustomHeader() -> DKHeader?
    func getHeaderDay() -> HeaderDay
    func canPullToRefresh() -> Bool
    func didPullToRefresh()
}

public extension DKTripListItem {
    var computedDepartureInfo: String {
        if let departureCity = getDepartureCity(), !departureCity.isCompletelyEmpty() && DKAddress.isEmpty(departureCity) {
            return departureCity
        } else {
            return getDepartureAddress() ?? ""
        }
    }

    var computedArrivalInfo: String {
        if let arrivalCity = getArrivalCity(), !arrivalCity.isCompletelyEmpty() && DKAddress.isEmpty(arrivalCity) {
            return arrivalCity
        } else {
            return getArrivalAddress() ?? ""
        }
    }
}
