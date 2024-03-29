//
//  DKVehicleType+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule

extension DKVehicleType: VehiclePickerTableViewItem {

    func text() -> String {
        switch self {
            case .car:
                return "dk_vehicle_type_car_title".dkVehicleLocalized()
            case .truck:
                return "dk_vehicle_type_truck_title".dkVehicleLocalized()
            @unknown default:
                return ""
        }
    }
}
