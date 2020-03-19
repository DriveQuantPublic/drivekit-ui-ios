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
    var fields : VehicleGroupField
    var vehicleCore : VehicleDetailVC
    var delegate : VehicleDetailDelegate? = nil
    
    init(fields: VehicleGroupField, vehicleCore: VehicleDetailVC) {
        self.fields = fields
        self.vehicleCore = vehicleCore
    }
}
