// swiftlint:disable all
//
//  OdometerVehicleCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 26/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule

struct OdometerVehicleCellViewModel {
    private let vehicle: DKVehicle

    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
    }

    func getVehicleName() -> String {
        return self.vehicle.computeName()
    }

    func getVehicleImage() -> UIImage? {
        return self.vehicle.getVehicleImage()
    }
}
