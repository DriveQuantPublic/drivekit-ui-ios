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

class VehiclesListCellViewModel {
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
    
    func updateDetectionMode(detectionMode: DKDetectionMode) {
        let vehicleId = vehicle.vehicleId
        let previousDetectionMode = vehicle.detectionMode ?? .disabled
            self.checkPreviousDetectionMode(previous: previousDetectionMode, new: detectionMode, completionHandler: { status in
                if status {
                    DriveKitVehicleManager.shared.updateDetectionMode(vehicleId: vehicleId, detectionMode: detectionMode, forceGPSVehicleUpdate: true, completionHandler: { status in
                        if status == .success {
                            self.delegate?.didUpdateVehicle()
                        } else {
                            self .delegate?.didReceiveErrorFromService()
                        }
                    })
                }
            })
        
    }
    
    func checkPreviousDetectionMode(previous: DKDetectionMode, new: DKDetectionMode, completionHandler: @escaping(Bool) -> ()) {
        if previous != new {
            if previous == .beacon {
                DriveKitVehicleManager.shared.removeBeacon(vehicleId: vehicle.vehicleId, completionHandler: { status in
                    if status == .success {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                })
            } else if previous == .bluetooth {
                DriveKitVehicleManager.shared.removeBluetooth(vehicleId: vehicle.vehicleId, completionHandler: { status in
                    if status == .success {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                })
            } else {
                completionHandler(true)
            }
        } else {
            completionHandler(true)
        }
    }
    
    
    
    func getDisplayName() -> String {
        return vehicle.getDisplayNameInList(vehiclesList: vehicles)
    }
    
    func getSubtitle() -> String? {
        if vehicle.liteConfig {
            if vehicle.name == vehicle.getCategoryName() {
                return nil
            } else {
                return vehicle.getCategoryName()
            }
        } else {
            return vehicle.getModel()
        }
    }
    
    func computeVehicleOptions() -> [VehicleOption] {
        var options : [VehicleOption] = []
        
        if !vehicle.liteConfig {
            options.append(.show)
        }
        
        if DriveKitVehiculeUI.shared.enableRenameVehicles {
            options.append(.rename)
        }
        
        if DriveKitVehiculeUI.shared.enableReplaceVehicles {
            options.append(.replace)
        }
        
        if DriveKitVehiculeUI.shared.enableDeleteVehicles {
            options.append(.delete)
        }
        
        return options
    }
}
