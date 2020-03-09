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
            return "GASOLINE"
        case .diesel:
            return "DIESEL"
        case .electric:
            return "ELECTRIC"
        case .gasolineHybrid:
            return "GASOLINE_HYBRID"
        case .dieselHybrid:
            return "DIESEL_HYBRID"
        }
    }
}
