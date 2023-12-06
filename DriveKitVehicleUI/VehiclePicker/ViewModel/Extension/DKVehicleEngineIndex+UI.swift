//
//  DKVehicleEngineIndex+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule

extension DKVehicleEngineIndex: VehiclePickerTableViewItem {
    // swiftlint:disable:next cyclomatic_complexity
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
        case .plugInGasolineHybrid:
            return "dk_vehicle_engine_gasoline_hybrid_plug_in".dkVehicleLocalized()
        case .biofuel:
            return "dk_vehicle_engine_biofuel".dkVehicleLocalized()
        case .biFuelBioethanol:
            return "dk_vehicle_engine_bi_fuel_bioethanol".dkVehicleLocalized()
        case .biFuelNGV:
            return "dk_vehicle_engine_bi_fuel_ngv".dkVehicleLocalized()
        case .biFuelLPG:
            return "dk_vehicle_engine_bi_fuel_lpg".dkVehicleLocalized()
        case .notAvailable:
            return "-"
        case .hydrogen:
            return "dk_vehicle_engine_hydrogen".dkVehicleLocalized()
        @unknown default:
            return ""
        }
    }
}
