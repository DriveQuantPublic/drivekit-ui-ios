//
//  OdometerVehicleListViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 06/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule
import AVFoundation

class OdometerVehicleListViewModel {
    private var vehicle: DKVehicle?
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?

    init(vehicleId: String?) {
        if let vehicleId = vehicleId, let vehicle = DriveKitVehicle.getVehicle(withId: vehicleId) {
            self.vehicle = vehicle
        } else {
            self.vehicle = DriveKitVehicle.getVehicles().first
        }
        self.odometer = self.vehicle?.odometer
        self.odometerHistories = self.vehicle?.odometerHistories
    }

    func synchronize(completion: @escaping (Bool) -> ()) {
        if let vehicle = self.vehicle {
            DriveKitVehicle.shared.getOdometer(vehicleId: vehicle.vehicleId, type: .defaultSync) { status, odometer, odometerHistories in
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
        } else if hasVehicles() {
            completion(false)
        } else {
            completion(true)
        }
    }

    private func synchronizeOdometer(vehicleId: String, completion: @escaping (Bool) -> ()) {
        DriveKitVehicle.shared.getOdometer(vehicleId: vehicleId, type: .defaultSync) { status, odometer, odometerHistories in
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

    func updateVehicle(vehicleId: String) {
        if let vehicle = DriveKitVehicle.getVehicle(withId: vehicleId) {
            self.vehicle = vehicle
            self.odometer = self.vehicle?.odometer
            self.odometerHistories = self.vehicle?.odometerHistories
        }
    }

    func hasVehicles() -> Bool {
        return DriveKitVehicle.hasVehicles()
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

    func getOdometerVehicleDetailViewModel() -> OdometerVehicleDetailViewModel? {
        if let vehicle = self.vehicle {
            return OdometerVehicleDetailViewModel(vehicleId: vehicle.vehicleId)
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

    func getVehicleFilterViewModel(delegate: DKFilterItemDelegate) -> DKFilterViewModel? {
        let vehicleFilterItems = DriveKitVehicleUI.shared.getVehicleFilterItems()
        if !vehicleFilterItems.isEmpty {
            let filterViewModel = DKFilterViewModel(items: vehicleFilterItems, currentItem: vehicleFilterItems[0], showPicker: true, delegate: delegate)
            return filterViewModel
        } else {
            return nil
        }
    }
}
