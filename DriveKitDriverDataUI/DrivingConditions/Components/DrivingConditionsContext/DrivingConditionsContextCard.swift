//
//  DrivingConditionsContextCard.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 18/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

protocol DrivingConditionsContextCard: DKContextCard {
    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions)
}
