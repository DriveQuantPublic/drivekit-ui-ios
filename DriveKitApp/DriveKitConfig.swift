//
//  DriveKitConfig.swift
//  DriveKitApp
//
//  Created by David Bauduin on 26/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDriverDataUI

class DriveKitConfig {
    static let isAutoStartPostponable = true
    static let tripData: TripData = .safety
    static let enableAlternativeTrips = true

    static func configureDriveKit() {
        //TODO
    }
}
