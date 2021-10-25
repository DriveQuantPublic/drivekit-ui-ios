//
//  OdometerHistoryDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 26/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

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
                return ""
            case .vehicle:
                return ""
        }
    }
}

class OdometerHistoryDetailViewModel {
    private var vehicle: DKVehicle
    private var history: DKVehicleOdometerHistory?
    private var cellsReferences: [ReferenceCellType]
    private var selectedRef: DKVehicleOdometerHistory? = nil
    private var prevRef: DKVehicleOdometerHistory? = nil

    private var updatedRefDate: Date? = nil
    private var updatedValue: Double? = nil

    init(vehicle: DKVehicle, history: DKVehicleOdometerHistory?, isEditable: Bool) {
        self.vehicle = vehicle
        self.history = history
        self.cellsReferences = [.distance, .date, .vehicle(vehicle)]
//        self.configureOdometer(vehicle: vehicle)
    }

    func update() {
        #warning("TODO")
//        self.odometer = vehicle.odometer
//        if let history = vehicle.odometerHistories {
//            self.histories = history.sorted(by: {$0.updateDate ?? Date() > $1.updateDate ?? Date()})
//        }
    }
}
