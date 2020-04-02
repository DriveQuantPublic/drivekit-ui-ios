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

protocol VehiclesListDelegate : AnyObject{
    func onVehiclesAvailable()
    func didUpdateVehicle()
    func didReceiveErrorFromService()
    func showAlert(_ alertController: UIAlertController)
    func showLoader()
    func hideLoader()
}


class VehiclesListViewModel {
    private var vehicles: [DKVehicle] = []
    weak var delegate: VehiclesListDelegate? = nil
    
    func fetchVehicles() {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(completionHandler : { status, vehicles in
            DispatchQueue.main.async {
                self.vehicles = self.orderVehiclesByDisplayName(vehicles: vehicles)
                self.delegate?.onVehiclesAvailable()
            }
        })
    }
    
    private func orderVehiclesByDisplayName(vehicles: [DKVehicle]) -> [DKVehicle] {
        return vehicles.sorted { $0.getDisplayName(position: $0.getPosition(vehiclesList: vehicles)).lowercased() < $1.getDisplayName(position: $0.getPosition(vehiclesList: vehicles)).lowercased() }
    }
    
    var vehiclesCount : Int {
        return vehicles.count
    }
    
    var vehicleActions : [VehicleAction] {
        var actions = DriveKitVehicleUI.shared.vehicleActions
        if vehiclesCount <= 1 {
            actions.removeAll(where: {$0 == .delete})
        }
        return actions
    }
    
    var detectionModes : [DKDetectionMode] {
        return DriveKitVehicleUI.shared.detectionModes
    }
    
    func vehicleName(pos : Int) -> String {
        return vehicles[pos].getDisplayName(position: pos)
    }
    
    func vehicleModel(pos: Int) -> String {
        var model = ""
        let vehicle = vehicles[pos]
        if vehicle.liteConfig {
            if vehicle.name != vehicle.getLiteConfigCategoryName(){
                model =  vehicle.getLiteConfigCategoryName()
            }
        } else {
            model = vehicle.getModel()
        }
        return model
    }
    
    func detectionModeTitle(pos: Int) -> String {
        return vehicles[pos].detectionMode?.title ?? ""
    }
    
    func detectionModeDescription(pos: Int) -> NSAttributedString {
        return vehicles[pos].detectionModeDescription
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

