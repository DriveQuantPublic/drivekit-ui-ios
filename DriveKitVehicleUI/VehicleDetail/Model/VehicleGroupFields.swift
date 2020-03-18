//
//  VehicleGroupFields.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

enum VehicleGroupField {
    case general, engine, characteristics, beacon, bluetooth
    
    func isDisplayable() -> Bool {
        switch self {
        case .general:
            return true
        case .engine:
            return true
        case .characteristics:
            return true
        case .beacon:
            return true
        case .bluetooth:
            return true
        }
    }
    
    func getFields(vehicle: DKVehicle) -> [VehicleField] {
        switch self {
        case .general:
            return GeneralField.allCases
        case .characteristics:
            return CharacteristicsField.allCases
        case .engine:
            return EngineField.allCases
        case .beacon:
            return BeaconField.allCases
        case .bluetooth:
            return BluetoothField.allCases
        }
    }
}
