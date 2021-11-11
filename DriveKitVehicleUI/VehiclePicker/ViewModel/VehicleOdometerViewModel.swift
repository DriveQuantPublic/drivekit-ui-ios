//
//  VehicleOdometerViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/04/2020.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule

class VehicleOdometerViewModel {
    let vehicleId: String

    init(vehicleId: String) {
        self.vehicleId = vehicleId
    }

    func addOdometer(distance: Double, completion: @escaping (Bool, String?) -> ()) {
        DriveKitVehicle.shared.addOdometerHistory(vehicleId: self.vehicleId, distance: distance) { status, odometer, histories in
            if status == .success {
                completion(true, nil)
            } else {
                let error: String?
                switch status {
                    case .badDistance:
                        error = "dk_vehicle_odometer_bad_distance".dkVehicleLocalized()
                    case .vehicleNotFound:
                        error = "dk_vehicle_not_found".dkVehicleLocalized()
                    case .error:
                        error = "dk_vehicle_odometer_failed_to_sync".dkVehicleLocalized()
                    default:
                        error = nil
                }
                completion(false, error)
            }
        }
    }
}
