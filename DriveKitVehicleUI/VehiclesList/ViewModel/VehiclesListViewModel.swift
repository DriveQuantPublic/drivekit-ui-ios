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
        return vehicle.detectionMode ?? .disabled
    }
    
    func renameVehicle(vehicle: DKVehicle, name: String) {
            DriveKitVehicleManager.shared.renameVehicle(name: name, vehicleId: vehicle.vehicleId, completionHandler: { status in
                if status == .success {
                    self.delegate?.didUpdateVehicle()
                } else {
                    self .delegate?.didReceiveErrorFromService()
                }
            })
    }
    
    func deleteVehicle(vehicle: DKVehicle) {
        DriveKitVehicleManager.shared.deleteVehicle(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self .delegate?.didReceiveErrorFromService()
            }
        })
    }
    
    func deleteBluetooth(vehicle: DKVehicle) {
        DriveKitVehicleManager.shared.removeBluetooth(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            } else {
                self .delegate?.didReceiveErrorFromService()
            }
        })
    }
    
    func deleteBeacon(vehicle: DKVehicle) {
        DriveKitVehicleManager.shared.removeBeacon(vehicleId: vehicle.vehicleId, completionHandler: { status in
            if status == .success {
                self.delegate?.didUpdateVehicle()
            }
        })
    }
    
    func computeDetectionMode() -> DKDetectionMode {
        let detectionModes = DriveKitVehiculeUI.shared.detectionModes
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
