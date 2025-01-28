//
//  DKTripInfo.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 16/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import UIKit

public protocol DKTripInfo {
    func infoText(trip: DKTrip) -> String?
    func infoImage(trip: DKTrip) -> UIImage?
    func infoClickAction(parentViewController: UIViewController, trip: DKTrip)
    func hasInfoActionConfigured(trip: DKTrip) -> Bool
    func isInfoDisplayable(trip: DKTrip) -> Bool
}
