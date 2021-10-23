//
//  OdometerVehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 08/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule

class OdometerVehicleDetailViewModel {
    var vehicle: DKVehicle
    var odometer: DKVehicleOdometer?
    var cells: [OdometerCellType] = []

    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
        self.odometer = vehicle.odometer
        self.cells = [ .odometer, .analyzedDistance, .estimatedDistance]
    }

    func configureVehicle(vehicle: DKVehicle) {
        self.vehicle = vehicle
        self.odometer = vehicle.odometer
    }
}
