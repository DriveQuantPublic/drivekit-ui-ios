//
//  OdometerHistoriesViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

class OdometerHistoriesViewModel {
    private var vehicle: DKVehicle
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?

    init(vehicle: DKVehicle, odometer: DKVehicleOdometer?, odometerHistories: [DKVehicleOdometerHistory]?) {
        self.vehicle = vehicle
        self.odometer = odometer
        self.odometerHistories = odometerHistories
    }

    func update() {
        if let vehicle = DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: self.vehicle.vehicleId).queryOne().execute() {
            self.vehicle = vehicle
            self.odometer = vehicle.odometer
            if let odometerHistories = vehicle.odometerHistories {
                self.odometerHistories = odometerHistories.sorted { $0.updateDate ?? Date() > $1.updateDate ?? Date() }
            }
        }
    }

    func getOdometerHistoryDetailViewModel(atIndex index: Int) -> OdometerHistoryDetailViewModel {
        let history = getHistory(atIndex: index)
        return OdometerHistoryDetailViewModel(vehicle: self.vehicle, history: history, isEditable: index == 0)
    }

    func getNewOdometerHistoryDetailViewModel() -> OdometerHistoryDetailViewModel {
        return OdometerHistoryDetailViewModel(vehicle: self.vehicle, history: nil, isEditable: true)
    }

    func getOdometerHistoriesCellViewModel(atIndex index: Int) -> OdometerHistoriesCellViewModel? {
        if let history = getHistory(atIndex: index) {
            return OdometerHistoriesCellViewModel(history: history)
        } else {
            return nil
        }
    }

    func getNumberOfHistories() -> Int {
        return self.odometerHistories?.count ?? 0
    }

    func canDeleteHistory() -> Bool {
        return self.getNumberOfHistories() > 1
    }

    func deleteHistory(atIndex index: Int, completion: @escaping (Bool) -> ()) {
        if let history = getHistory(atIndex: index) {
            DriveKitVehicle.shared.deleteOdometerHistory(vehicleId: self.vehicle.vehicleId, historyId: String(history.historyId)) { status, odometer, histories in
                self.odometer = odometer
                self.odometerHistories = histories
                DispatchQueue.dispatchOnMainThread {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }

    private func getHistory(atIndex index: Int) -> DKVehicleOdometerHistory? {
        if let odometerHistories = self.odometerHistories, index >= 0 && index < odometerHistories.count {
            return odometerHistories[index]
        } else {
            return nil
        }
    }
}
