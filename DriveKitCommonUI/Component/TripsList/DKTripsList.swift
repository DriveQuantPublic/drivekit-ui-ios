//
//  DKTripList.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DKTripsListItem {
    func getItinId() -> String
    func getDuration() -> Double
    func getDistance() -> Double?
    func getStartDate() -> Date?
    func getEndDate() -> Date
    func getDepartureCity() -> String?
    func getArrivalCity() -> String?
    func isScored(tripData: TripData) -> Bool
    func getScoreText(tripData: TripData) -> String?
    func getTransportationModeResource() -> UIImage?
    func isAlternative() -> Bool
    func getDisplayText() -> String
    func getDisplayType() -> DisplayType
    func infoText() -> String?
    func infoImageResource() -> UIImage?
    func infoClickAction(parentViewController: UIViewController)
    func hasInfoActionConfigured() -> Bool
    func isInfoDisplayable() -> Bool
}

public protocol DKTripsList {
    func onTripClickListener(itinId: String)
    func getTripData() -> TripData
    func getTripsList() -> [DKTripsByDate]
}
