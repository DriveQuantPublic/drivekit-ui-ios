//
//  OdometerVehicleListViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 06/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule

class OdometerVehicleListViewModel {
    private let vehicles: [DKVehicle]
    private let vehicle: DKVehicle
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?

    init(vehicles: [DKVehicle], index: Int) {
        self.vehicles = vehicles
        self.vehicle = vehicles[index]
        self.odometer = self.vehicle.odometer
        self.odometerHistories = self.vehicle.odometerHistories
    }

    func update(completion: @escaping (Bool) -> ()) {
        DriveKitVehicle.shared.getOdometer(vehicleId: self.vehicle.vehicleId, type: .defaultSync) { status, odometer, odometerHistories in
            DispatchQueue.dispatchOnMainThread {
                if status != .vehicleNotFound {
                    self.odometer = odometer
                    self.odometerHistories = odometerHistories
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func getOdometerCellViewModel() -> OdometerCellViewModel {
        return OdometerCellViewModel(odometer: self.odometer)
    }

    func getOdometerVehicleCellViewModel() -> OdometerVehicleCellViewModel {
        return OdometerVehicleCellViewModel(vehicle: self.vehicle)
    }

    func getOdometerVehicleDetailViewModel() -> OdometerVehicleDetailViewModel {
        return OdometerVehicleDetailViewModel(vehicle: self.vehicle, odometer: self.odometer, odometerHistories: self.odometerHistories)
    }

    func getOdometerHistoriesViewModel() -> OdometerHistoriesViewModel {
        return OdometerHistoriesViewModel(vehicle: self.vehicle, odometer: self.odometer, odometerHistories: self.odometerHistories)
    }

    func getOdometerHistoryDetailViewModel() -> OdometerHistoryDetailViewModel {
        return OdometerHistoryDetailViewModel(vehicle: self.vehicle, history: nil, isEditable: true)
    }
}
