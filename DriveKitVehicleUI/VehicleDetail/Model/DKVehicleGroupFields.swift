//
//  VehicleGroupFields.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule

public enum DKVehicleGroupField: CaseIterable {
    case general, engine, characteristics, beacon, bluetooth

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return self.getFields(vehicle: vehicle).count > 0 ? true : false
    }

    func getFields(vehicle: DKVehicle) -> [DKVehicleField] {
        var fields: [DKVehicleField] = []
        var allFields: [DKVehicleField] = []
        switch self {
            case .general:
                allFields = GeneralField.allCases
            case .characteristics:
                allFields = CharacteristicsField.allCases
            case .engine:
                allFields = vehicle.isTruck() ? [] : EngineField.allCases
            case .beacon:
                allFields = BeaconField.allCases
            case .bluetooth:
                allFields = BluetoothField.allCases
        }
        for field in allFields {
            if field.isDisplayable(vehicle: vehicle) {
                fields.append(field)
            }
        }

        if let customFields = getCustomFields() {
            fields.append(contentsOf: customFields.filter { $0.isDisplayable(vehicle: vehicle) })
        }

        return fields
    }

    func getCustomFields() -> [DKVehicleField]? {
        return DriveKitVehicleUI.shared.customFields[self]
    }
    
}
