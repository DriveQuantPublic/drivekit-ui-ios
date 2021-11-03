//
//  OdometerCellType.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 25/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

enum OdometerCellType {
    case odometer
    case analyzedDistance
    case estimatedDistance

    var titleKey: String {
        switch self {
            case .odometer:
                return "dk_vehicle_odometer_vehicle_title"
            case .analyzedDistance:
                return "dk_vehicle_odometer_distance_analyzed"
            case .estimatedDistance:
                return "dk_vehicle_odometer_estimated_distance"
        }
    }

    var descriptionKey: String {
        switch self {
            case .odometer:
                return "dk_vehicle_odometer_last_update"
            case .analyzedDistance:
                return "dk_vehicle_odometer_distance_analyzed_subtitle"
            case .estimatedDistance:
                return "dk_vehicle_odometer_estimated_distance_subtitle"
        }
    }
}
