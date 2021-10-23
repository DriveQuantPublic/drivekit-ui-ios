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
    private var vehicles: [DKVehicle]
    private var vehicleIndex: Int
    private static var lastSyncDate: Date? = nil

    var currentVehicle: DKVehicle {
        return vehicles[vehicleIndex]
    }
    
    init(sortedVehicles: [DKVehicle], index: Int) {
        self.vehicleIndex = index
        self.vehicles = sortedVehicles
    }

    func fetchOdometer(completion: @escaping (Bool) -> ()) {
        #warning("Pull to refresh")
        let type: DKVehicleSynchronizationType
        if let lastSyncDate = OdometerVehicleListViewModel.lastSyncDate, -lastSyncDate.timeIntervalSinceNow < 600 {
            type = .cache
        } else {
            type = .defaultSync
            OdometerVehicleListViewModel.lastSyncDate = Date()
        }
        #warning("User odometer service")
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: type) { status, vehicles in
            DispatchQueue.main.async {
                if status != .syncAlreadyInProgress {
                    let currentVehicleId = self.currentVehicle.vehicleId
                    self.vehicles = vehicles
                    self.vehicleIndex = vehicles.firstIndex(where: { $0.vehicleId == currentVehicleId }) ?? 0
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
