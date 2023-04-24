//
//  DrivingConditionsConstants.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 24/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation

enum DrivingConditionsConstants {
    static let minTotalDistanceForDisplayingFractions: Double = 10
    static let minDistanceToRemoveFractions: Double = 100
    
    static func minDistanceToRemoveFractions(forTotalDistance totalDistance: Double) -> Double {
        totalDistance < minTotalDistanceForDisplayingFractions ? minDistanceToRemoveFractions : 0
    }
}
