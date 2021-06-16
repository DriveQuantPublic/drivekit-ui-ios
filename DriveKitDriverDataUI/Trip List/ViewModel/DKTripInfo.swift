//
//  DKTripInfo.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 16/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

public protocol DKTripInfo {
    func infoText(trip: Trip) -> String?
    func infoImage(trip: Trip) -> UIImage?
    func infoClickAction(parentViewController: UIViewController, trip: Trip)
    func hasInfoActionConfigured(trip: Trip) -> Bool
    func isInfoDisplayable(trip: Trip) -> Bool
}
