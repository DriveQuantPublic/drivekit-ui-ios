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
        DriveKitVehicleManager.shared.getVehiclesOrderByNameAsc(completionHandler : { status, vehicles in
            DispatchQueue.main.async {
                self.status = status
                self.vehicles = vehicles
                self.delegate?.onVehiclesAvailable()
            }
        })
    }
    
    func getDetectionMode(vehicle: DKVehicle) -> DKDetectionMode {
        return DKDetectionMode(value: vehicle.detectionMode ?? "DISABLED")
    }
    
    func renameVehicle(vehicle: DKVehicle, name: String) {
        if let vehicleId = vehicle.vehicleId {
            DriveKitVehicleManager.shared.renameVehicle(name: name, vehicleId: vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                } else {
                    self .delegate?.didReceiveErrorFromService()
                }
            })
        }
    }
    
    func deleteVehicle(vehicle: DKVehicle) {
        if let vehicleId = vehicle.vehicleId {
            DriveKitVehicleManager.shared.deleteVehicle(vehicleId: vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                } else {
                    self .delegate?.didReceiveErrorFromService()
                }
            })
        }
    }
    
    func deleteBluetooth(vehicle: DKVehicle) {
        if let vehicleId = vehicle.vehicleId {
            DriveKitVehicleManager.shared.removeBluetooth(vehicleId: vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                } else {
                    self .delegate?.didReceiveErrorFromService()
                }
            })
        }
    }
    
    func deleteBeacon(vehicle: DKVehicle) {
        if let vehicleId = vehicle.vehicleId {
            DriveKitVehicleManager.shared.removeBeacon(vehicleId: vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                }
            })
        }
    }
    
    func computeDetectionMode() -> DKDetectionMode {
        let detectionModes = DriveKitVehiculeUI.shared.detectionModes
        if detectionModes.isEmpty {
            return .disabled
        } else if detectionModes.contains(.gps) {
            let vehiclesGPS = vehicles.filter { $0.detectionMode == DKDetectionMode.gps.value }
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
