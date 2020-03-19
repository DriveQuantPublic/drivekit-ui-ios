//
//  VehicleGroupFields.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

enum VehicleGroupField: CaseIterable {
    case general, engine, characteristics, beacon, bluetooth
    
    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return self.getFields(vehicle: vehicle).count > 0 ? true : false
    }
    
    func getFields(vehicle: DKVehicle) -> [VehicleField] {
        var fields: [VehicleField] = []
        var allFields: [VehicleField] = []
        switch self {
        case .general:
            allFields = GeneralField.allCases
        case .characteristics:
            allFields = CharacteristicsField.allCases
        case .engine:
            allFields = EngineField.allCases
        case .beacon:
            allFields = BeaconField.allCases
        case .bluetooth:
            allFields = BluetoothField.allCases
        }
        for field in allFields {
            if field.getValue(vehicle: vehicle) != nil {
                fields.append(field)
            }
        }
        return fields
    }
}
