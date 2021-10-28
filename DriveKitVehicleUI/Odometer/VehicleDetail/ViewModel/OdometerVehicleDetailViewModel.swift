//
//  OdometerVehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

class OdometerVehicleDetailViewModel {
    private var vehicle: DKVehicle
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?
    let cells: [OdometerCellType] = [.odometer, .analyzedDistance, .estimatedDistance]

    init(vehicle: DKVehicle, odometer: DKVehicleOdometer?, odometerHistories: [DKVehicleOdometerHistory]?) {
        self.vehicle = vehicle
        self.odometer = odometer
        self.odometerHistories = odometerHistories
    }

    func update() {
        if let vehicle = DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: self.vehicle.vehicleId).queryOne().execute() {
            self.vehicle = vehicle
            self.odometer = vehicle.odometer
            self.odometerHistories = vehicle.odometerHistories
        }
    }

    func showReferenceLink() -> Bool {
        return !(self.odometerHistories?.isEmpty ?? true)
    }

    func getOdometerCellViewModel() -> OdometerCellViewModel {
        return OdometerCellViewModel(odometer: self.odometer)
    }

    func getOdometerVehicleCellViewModel() -> OdometerVehicleCellViewModel {
        return OdometerVehicleCellViewModel(vehicle: self.vehicle)
    }

    func getOdometerHistoriesViewModel() -> OdometerHistoriesViewModel {
        return OdometerHistoriesViewModel(vehicle: self.vehicle, odometer: self.odometer, odometerHistories: self.odometerHistories)
    }

    func getNewOdometerHistoryDetailViewModel() -> OdometerHistoryDetailViewModel {
        return OdometerHistoryDetailViewModel.addHistoryViewModel(vehicle: self.vehicle, odometer: self.odometer, odometerHistories: self.odometerHistories)
    }
}
