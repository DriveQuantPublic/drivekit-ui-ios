//
//  DKTripList.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

protocol DKTripsListItem {
    func getItinId() -> String
    func getDuration() -> Double
    func getDistance() -> Double?
    func getEndDate() -> Date
    func getDepartureCity() -> String
    func getArrivalCity() -> String
    func isScored(tripData: TripData) -> Boolean
    func getScore(tripData: TripData) -> Boolean?
    func getTransportationModeResource() -> UIImage?
    func getDisplayText() -> String
    func getDisplayType() -> DisplayType
    func infoText() -> String?
    func infoImageResource() -> UIImage?
    func infoClickAction(parentViewController: UIViewController)
    func hasInfoActionConfigured() -> Boolean
    func isDisplayable() -> String?
}

protocol DKTripsList {
    func onTripClickListener(itinId: String)
    func getTripData() -> TripData
    func getTripsList() -> [DKTripListItem]
}
