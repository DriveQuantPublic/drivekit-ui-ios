//
//  DKVehicleEngineIndex+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension DKVehicleEngineIndex : VehiclePickerTableViewItem {
    func text() -> String {
        switch self {
        case .gasoline:
            return "dk_vehicle_engine_gasoline".dkVehicleLocalized()
        case .diesel:
            return "dk_vehicle_engine_diesel".dkVehicleLocalized()
        case .electric:
            return "dk_vehicle_engine_electric".dkVehicleLocalized()
        case .gasolineHybrid:
            return "dk_vehicle_engine_gasoline_hybrid".dkVehicleLocalized()
        case .dieselHybrid:
            return "dk_vehicle_engine_diesel_hybrid".dkVehicleLocalized()
        }
    }
}
