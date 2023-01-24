// swiftlint:disable all
//
//  ChallengeStatType.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI

enum ChallengeStatType {
    case duration, distance, nbTrips
    
    var image: UIImage? {
        switch self {
        case .duration:
            return DKImages.clock.image
        case .distance:
            return DKImages.road.image
        case .nbTrips:
            return DKImages.trip.image
        }
    }
}
