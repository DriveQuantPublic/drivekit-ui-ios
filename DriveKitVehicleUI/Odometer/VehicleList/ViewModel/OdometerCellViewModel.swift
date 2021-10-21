//
//  OdometerCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

enum OdometerCellType {
    case odometer
    case analyzedDistance
    case estimatedDistance
    
    var title: String {
        switch self {
            case .odometer:
                #warning("Manage new string")
                return "TODO-odometer_vehicle_title".dkVehicleLocalized()
            case .analyzedDistance:
                #warning("Manage new string")
                return "TODO-odometer_distance_analyzed".dkVehicleLocalized()
            case .estimatedDistance:
                #warning("Manage new string")
                return "TODO-odometer_estimated_distance".dkVehicleLocalized()
        }
    }
    
    var subtitle: String {
        switch self {
            case .odometer:
                #warning("Manage new string")
                return "TODO-odometer_last_update".dkVehicleLocalized()
            case .analyzedDistance:
                #warning("Manage new string")
                return "TODO-odometer_distance_analyzed_subtitle".dkVehicleLocalized()
            case .estimatedDistance:
                #warning("Manage new string")
                return "TODO-odometer_estimated_distance_subtitle".dkVehicleLocalized()
        }
    }
}

struct OdometerCellViewModel {
    let vehicle: DKVehicle
    let lastUpdate: Date
    let index: IndexPath
    let type: OdometerCellType
    let optionButton: Bool
    let alertButton: Bool
    let value: String
    let subtitle: String
    let alertTitle: String
    let alertMessage: String

    init(vehicle: DKVehicle, index: IndexPath, type: OdometerCellType, optionButton: Bool, alertButton: Bool = false) {
        self.vehicle = vehicle
        self.index = index
        self.type = type
        self.optionButton = optionButton
        self.alertButton = alertButton
        self.lastUpdate = vehicle.odometer?.updateDate ?? Date()
        switch self.type {
            case .odometer:
                value = vehicle.odometer?.distance.formatKilometerDistance() ?? "0"
                subtitle = String(format: type.subtitle, self.lastUpdate.format(pattern: .standardDate))
                #warning("Manage new string")
                alertTitle = "TODO-odometer_info_vehicle_distance_title".dkVehicleLocalized()
                #warning("Manage new string")
                alertMessage = "TODO-odometer_info_vehicle_distance_text".dkVehicleLocalized()
            case .analyzedDistance:
                value = vehicle.odometer?.analyzedDistance.formatKilometerDistance() ?? "0"
                subtitle = String(format: type.subtitle, vehicle.odometer?.yearAnalyzedDistance.formatKilometerDistance() ?? "0")
                #warning("Manage new string")
                alertTitle = "TODO-odometer_info_analysed_distance_title".dkVehicleLocalized()
                #warning("Manage new string")
                alertMessage = "TODO-odometer_info_analysed_distance_text".dkVehicleLocalized()
            case .estimatedDistance:
                value = vehicle.odometer?.estimatedYearDistance.formatKilometerDistance() ?? "0"
                let calendar = Calendar.current
                subtitle = String(format: type.subtitle, String(calendar.component(.year, from: self.lastUpdate)))
                #warning("Manage new string")
                alertTitle = "TODO-odometer_info_estimated_distance_title".dkVehicleLocalized()
                #warning("Manage new string")
                alertMessage = "TODO-odometer_info_estimated_distance_text".dkVehicleLocalized()
        }
    }
}
