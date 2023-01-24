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
    private var vehicle: DKVehicle?
    private var odometer: DKVehicleOdometer?
    private var odometerHistories: [DKVehicleOdometerHistory]?

    init(vehicleId: String) {
        let vehicle = DriveKitVehicle.getVehicle(withId: vehicleId)
        self.vehicle = vehicle
        self.odometer = vehicle?.odometer
        self.odometerHistories = sortHistories(vehicle?.odometerHistories)
    }

    func update() {
        if let vehicle = self.vehicle, let newVehicle = DriveKitVehicle.getVehicle(withId: vehicle.vehicleId) {
            self.vehicle = newVehicle
            self.odometer = newVehicle.odometer
            self.odometerHistories = sortHistories(newVehicle.odometerHistories)
        }
    }

    func getOdometerHistoryDetailViewModel(atIndex index: Int) -> OdometerHistoryDetailViewModel? {
        if let vehicle = self.vehicle {
            let history = getHistory(atIndex: index)
            let previousHistory = getHistory(atIndex: index + 1)
            return OdometerHistoryDetailViewModel(vehicleId: vehicle.vehicleId, historyId: history?.historyId, previousHistoryId: previousHistory?.historyId, isEditable: index == 0)
        } else {
            return nil
        }
    }

    func getNewOdometerHistoryDetailViewModel() -> OdometerHistoryDetailViewModel? {
        if let vehicle = self.vehicle {
            return OdometerHistoryDetailViewModel(vehicleId: vehicle.vehicleId, historyId: nil, previousHistoryId: self.odometerHistories?.first?.historyId, isEditable: true)
        } else {
            return nil
        }
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

    func deleteHistory(atIndex index: Int, completion: @escaping (Bool) -> Void) {
        if let vehicle = self.vehicle, let history = getHistory(atIndex: index) {
            DriveKitVehicle.shared.deleteOdometerHistory(vehicleId: vehicle.vehicleId, historyId: String(history.historyId)) { [weak self] _, odometer, histories in
                if let self = self {
                    self.odometer = odometer
                    self.odometerHistories = histories
                }
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

    private func sortHistories(_ odometerHistories: [DKVehicleOdometerHistory]?) -> [DKVehicleOdometerHistory]? {
        if let odometerHistories = odometerHistories {
            return odometerHistories.sorted { $0.updateDate ?? Date() > $1.updateDate ?? Date() }
        } else {
            return nil
        }
    }
}
