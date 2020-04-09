//
//  DKVehicleType+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension DKVehicleType : VehiclePickerTableViewItem {

    func text() -> String {
        switch self {
        case .car:
            return "dk_vehicle_type_car_title".dkVehicleLocalized()
        }
    }
}
