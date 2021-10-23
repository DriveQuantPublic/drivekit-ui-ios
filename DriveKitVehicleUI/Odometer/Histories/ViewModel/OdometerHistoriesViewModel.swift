//
//  OdometerHistoriesViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitCommonUI

enum ReferenceCellType {
    case distance
    case date
    case vehicle(DKVehicle)

    var isEditable: Bool {
        switch self {
            case .distance, .date:
                return true
            case .vehicle:
                return false
        }
    }

    var image: UIImage? {
        switch self {
            case .distance:
                return DKImages.ecoAccel.image
            case .date:
                return DKImages.calendar.image
            case .vehicle(let vehicle):
                return vehicle.getVehicleImage()
        }
    }

    var placeholder: String {
        switch self {
            case .distance:
                #warning("Manage new string")
                return "TODO-mileage_kilometer".dkVehicleLocalized()
            case .date:
                #warning("Manage new string")
                return "TODO-date".dkVehicleLocalized()
            case .vehicle:
                return ""
        }
    }
}

class OdometerHistoriesViewModel {
    var vehicle: DKVehicle
    var histories: [DKVehicleOdometerHistory] = []
    var odometer: DKVehicleOdometer?
    var index: Int = 0
    var cellsReferences: [ReferenceCellType]
    var selectedRef: DKVehicleOdometerHistory? = nil
    var prevRef: DKVehicleOdometerHistory? = nil
    var isWritable: Bool = false

    var updatedRefDate: Date? = nil
    var updatedValue: Double? = nil

    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
        self.cellsReferences = [.distance, .date, .vehicle(vehicle)]
        self.configureOdometer(vehicle: vehicle)
    }

    func configureOdometer(vehicle: DKVehicle) {
        self.vehicle = vehicle
        self.odometer = vehicle.odometer
        if let history = vehicle.odometerHistories {
            self.histories = history.sorted(by: {$0.updateDate ?? Date() > $1.updateDate ?? Date()})
        }
    }
}
