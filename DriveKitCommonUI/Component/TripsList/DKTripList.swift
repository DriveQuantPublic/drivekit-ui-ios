//
//  DKTripList.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public protocol DKTripListItem {
    func getItinId() -> String
    func getDuration() -> Double
    func getDistance() -> Double?
    func getStartDate() -> Date?
    func getEndDate() -> Date
    func getDepartureCity() -> String?
    func getArrivalCity() -> String?
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

public protocol DKTripInfo {
    func infoText(itinId: String) -> String?
    func infoImage(itinId: String) -> UIImage?
    func infoClickAction(parentViewController: UIViewController, itinId: String)
    func hasInfoActionConfigured(itinId: String) -> Bool
    func isInfoDisplayable(itinId: String) -> Bool
}
