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
    private var vehicle: DKVehicle?
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?
    let cells: [OdometerCellType] = [.odometer, .analyzedDistance, .estimatedDistance]

    init(vehicleId: String) {
        let vehicle = DriveKitVehicle.getVehicle(withId: vehicleId)
        self.vehicle = vehicle
        self.odometer = vehicle?.odometer
        self.odometerHistories = vehicle?.odometerHistories
    }

    func update() {
        if let vehicle = self.vehicle, let newVehicle = DriveKitVehicle.getVehicle(withId: vehicle.vehicleId) {
            self.vehicle = newVehicle
            self.odometer = newVehicle.odometer
            self.odometerHistories = newVehicle.odometerHistories
        }
    }

    func showReferenceLink() -> Bool {
        return !(self.odometerHistories?.isEmpty ?? true)
    }

    func getOdometerCellViewModel() -> OdometerCellViewModel {
        return OdometerCellViewModel(vehicleId: self.vehicle?.vehicleId)
    }

    func getOdometerVehicleCellViewModel() -> OdometerVehicleCellViewModel? {
        if let vehicle = self.vehicle {
            return OdometerVehicleCellViewModel(vehicle: vehicle)
        } else {
            return nil
        }
    }

    func getOdometerHistoriesViewModel() -> OdometerHistoriesViewModel? {
        if let vehicle = self.vehicle {
            return OdometerHistoriesViewModel(vehicleId: vehicle.vehicleId)
        } else {
            return nil
        }
    }

    func getNewOdometerHistoryDetailViewModel() -> OdometerHistoryDetailViewModel? {
        if let vehicle = self.vehicle {
            return OdometerHistoryDetailViewModel(vehicleId: vehicle.vehicleId, historyId: nil, previousHistoryId: nil, isEditable: true)
        } else {
            return nil
        }
    }
}
