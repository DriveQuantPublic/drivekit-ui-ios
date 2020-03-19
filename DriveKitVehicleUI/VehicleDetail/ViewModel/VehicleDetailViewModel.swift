//
//  VehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

protocol VehicleDetailDelegate {
    func didUpdateVehicle()
    func didUpdateField()
}

class VehicleDetailViewModel {
    var fields: [VehicleGroupField] = []
    var vehicleDisplayName: String
    var vehicle: DKVehicle
    var updatedName: String = ""
    var hasError: Bool = false
    var delegate : VehicleDetailDelegate? = nil
    
    init(vehicle: DKVehicle, vehicleDisplayName: String) {
        self.vehicle = vehicle
        let groupFields = VehicleGroupField.allCases
        for groupField in groupFields {
            if groupField.isDisplayable(vehicle: vehicle) {
                fields.append(groupField)
            }
        }
    }
    
    
}
