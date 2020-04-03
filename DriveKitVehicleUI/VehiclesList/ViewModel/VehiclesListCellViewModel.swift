//
//  VehiclesListCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitVehicle
import DriveKitTripAnalysis

class VehiclesListCellViewModel2 {
    let listView: VehiclesListVC
    let vehicle: DKVehicle
    let vehicles: [DKVehicle]
    var delegate: VehiclesListDelegate? = nil
    var autoStart: AutoStart {
        if let detectionMode = vehicle.detectionMode {
            let mode = detectionMode
            switch mode {
            case .disabled:
                return .disabled
            case .gps:
                return .gps
            case .bluetooth:
                if vehicle.bluetooth != nil {
                    return .bluetooth
                } else {
                    return .bluetooth_disabled
                }
            case .beacon:
                if vehicle.beacon != nil {
                    return .beacon
                } else {
                    return .beacon_disabled
                }
            }
        } else {
            return .empty
        }
    }
    
    init(listView: VehiclesListVC, vehicle: DKVehicle, vehicles: [DKVehicle]) {
        self.listView = listView
        self.vehicle = vehicle
        self.vehicles = vehicles
    }
    
    func computeVehicleOptions() -> [VehicleAction] {
        var actions : [VehicleAction] = DriveKitVehicleUI.shared.vehicleActions
        if vehicle.liteConfig {
            if let index = actions.firstIndex(of: .show){
                actions.remove(at: index)
            }
        }
        return actions
    }
}
