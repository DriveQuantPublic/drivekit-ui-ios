//
//  VehicleListViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle
import DriveKitDBVehicleAccess

class VehiclesListViewModel {
    var vehicles: [DKVehicle] = []
    var status: DKVehicleSyncStatus = .noError
    var delegate: VehiclesListDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchVehicles()
            }
        }
    }
    
    func fetchVehicles() {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(completionHandler : { status, vehicles in
            DispatchQueue.main.async {
                self.status = status
                self.vehicles = self.orderVehiclesByDisplayName(vehicles: vehicles)
                self.delegate?.onVehiclesAvailable()
            }
        })
    }
    
    func orderVehiclesByDisplayName(vehicles: [DKVehicle]) -> [DKVehicle] {
        return vehicles.sorted { $0.getDisplayNameInList(vehiclesList: vehicles).lowercased() < $1.getDisplayNameInList(vehiclesList: vehicles).lowercased() }
    }
    
    func renameVehicle(vehicle: DKVehicle, name: String) {
            DriveKitVehicle.shared.renameVehicle(name: name, vehicleId: vehicle.vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                } else {
                    self .delegate?.didReceiveErrorFromService()
                }
            })
    }
    
    func deleteVehicle(vehicle: DKVehicle) {
        DriveKitVehicle.shared.deleteVehicle(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self .delegate?.didReceiveErrorFromService()
            }
        })
    }
    
    func deleteBluetooth(vehicle: DKVehicle) {
        DriveKitVehicle.shared.removeBluetooth(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self .delegate?.didReceiveErrorFromService()
            }
        })
    }
    
    func deleteBeacon(vehicle: DKVehicle) {
        DriveKitVehicle.shared.removeBeacon(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            }
        })
    }
    
    func computeDetectionMode() -> DKDetectionMode {
        let detectionModes = DriveKitVehicleUI.shared.detectionModes
        if detectionModes.isEmpty {
            return .disabled
        } else if detectionModes.contains(.gps) {
            let vehiclesGPS = vehicles.filter { $0.detectionMode ?? .disabled == DKDetectionMode.gps }
            if vehiclesGPS.isEmpty {
                return .gps
            } else {
                return detectionModes[0]
            }
        } else {
            return detectionModes[0]
        }
    }
}

protocol VehiclesListDelegate {
    func onVehiclesAvailable()
    func didUpdateVehicle()
    func didReceiveErrorFromService()
}
