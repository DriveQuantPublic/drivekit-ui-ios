//
//  DKTripInfo.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 27/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBTripAccessModule

public protocol DKTripInfo {
    func isDisplayable(trip: Trip) -> Bool
    func image(trip: Trip) -> UIImage?
    func text(trip: Trip) -> String?
    func hasActionConfigured() -> Bool
    func clickAction(trip: Trip, parentViewController: UIViewController)
}
