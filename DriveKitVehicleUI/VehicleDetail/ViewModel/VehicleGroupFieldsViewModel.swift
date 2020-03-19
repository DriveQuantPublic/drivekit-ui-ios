//
//  VehicleGroupFieldViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

class VehicleGroupFieldViewModel {
    var groupField : VehicleGroupField
    var fields: [VehicleField]
    var vehicleCore : VehicleDetailVC
    var delegate : VehicleDetailDelegate? = nil
    let vehicle: DKVehicle
    
    init(groupField: VehicleGroupField, vehicleCore: VehicleDetailVC, vehicle: DKVehicle) {
        self.groupField = groupField
        self.vehicleCore = vehicleCore
        self.vehicle = vehicle
        self.fields = groupField.getFields(vehicle: vehicle)
    }
}
