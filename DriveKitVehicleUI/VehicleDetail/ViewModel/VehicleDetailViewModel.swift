//
//  VehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitVehicle

protocol VehicleDetailDelegate {
    func didUpdateVehicle()
    func didUpdateField(field: VehicleField, value: String)
    func didFailUpdateField(field: VehicleField)
}

class VehicleDetailViewModel {
    var fields: [VehicleGroupField] = []
    var vehicleDisplayName: String
    var vehicle: DKVehicle
    var updatedName: String? = nil
    var errorFields: [VehicleField] = []
    var delegate : VehicleDetailDelegate? = nil
    var vehicleImage : String = ""
    var updatedFields: [VehicleField] = []
    
    init(vehicle: DKVehicle, vehicleDisplayName: String) {
        self.vehicle = vehicle
        self.vehicleDisplayName = vehicleDisplayName
        self.vehicleImage = "DQ_vehicle_" + vehicle.vehicleId
        let groupFields = VehicleGroupField.allCases
        for groupField in groupFields {
            if groupField.isDisplayable(vehicle: vehicle) {
                fields.append(groupField)
            }
        }
    }
    
    var hasError: Bool {
        return errorFields.count > 0 ? true : false
    }
    
    func updateFields(completion: @escaping((Bool) -> ())) {
        if let newName = updatedName {
            DriveKitVehicleManager.shared.renameVehicle(name: newName, vehicleId: vehicle.vehicleId, completionHandler: { status in
                if status == .success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
}
