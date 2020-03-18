//
//  VehicleField.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

protocol VehicleField {
    var title: String { get }
    var value: String { get }
    var isEditable: Bool { get }
    var keyBoardType: UIKeyboardType { get }
}

enum EngineField: VehicleField, CaseIterable {
    case engine, consumption, usageConsumption

    var title: String {
        switch self {
        case .engine:
            return "ENGINE"
        case .consumption:
            return "CONSUMPTION"
        case .usageConsumption:
            return "USAGE CONSUMPTION"
        }
    }
    
    var value: String {
        switch self {
        case .engine:
            return "ENGINE"
        case .consumption:
            return "CONSUMPTION"
        case .usageConsumption:
            return "USAGE CONSUMPTION"
        }
    }
    
    var isEditable: Bool {
        switch self {
        case .engine:
            return false
        case .consumption:
            return false
        case .usageConsumption:
            return false
        }
    }
    
    var keyBoardType: UIKeyboardType {
        return .default
    }
}

enum GeneralField: VehicleField, CaseIterable {
    case name, category, brand, model, version, year

    var title: String {
        switch self {
        case .name:
            return "NAME"
        case .category:
            return "CATEGORY"
        case .brand:
            return "BRAND"
        case .model:
            return "MODEL"
        case .version:
            return "VERSION"
        case .year:
            return "YEAR"
        }
    }
    
    var value: String {
        switch self {
        case .name:
            return "NAME"
        case .category:
            return "CATEGORY"
        case .brand:
            return "BRAND"
        case .model:
            return "MODEL"
        case .version:
            return "VERSION"
        case .year:
            return "YEAR"
        }
    }
    
    var isEditable: Bool {
        return false
    }
    
    var keyBoardType: UIKeyboardType {
        return .default
    }
    
}

enum BluetoothField: VehicleField, CaseIterable {
    case macAddress, bluetoothName
    
    var title: String {
        switch self {
        case .macAddress:
            return "MAC ADDRESS"
        case .bluetoothName:
            return "BLUETOOTH NAME"
        }
    }
    
    var value: String {
        switch self {
        case .macAddress:
            return "MAC ADDRESS"
        case .bluetoothName:
            return "BLUETOOTH NAME"
        }
    }
    
    var isEditable: Bool {
        return false
    }
    
    var keyBoardType: UIKeyboardType {
        return .default
    }
}

enum BeaconField: VehicleField, CaseIterable {
    case uniqueId, proximityUuid, minor, major

    var title: String {
        switch self {
        case .uniqueId:
            return "UNIQUE ID"
        case .proximityUuid:
            return "PROXIMITY UUID"
        case .minor:
            return "MINOR"
        case .major:
            return "MAJOR"
        }
    }
    
    var value: String {
        switch self {
        case .uniqueId:
            return "UNIQUE ID"
        case .proximityUuid:
            return "PROXIMITY UUID"
        case .minor:
            return "MINOR"
        case .major:
            return "MAJOR"
        }
    }
    
    var isEditable: Bool {
        return false
    }
    
    var keyBoardType: UIKeyboardType {
        return .default
    }
}

enum CharacteristicsField: VehicleField, CaseIterable {
    case power, gearbox, mass
    
    var title: String {
        switch self {
        case .power:
            return "POWER"
        case .gearbox:
            return "GEARBOX"
        case .mass:
            return "MASS"
        }
    }
    
    var value: String {
        switch self {
        case .power:
            return "POWER"
        case .gearbox:
            return "GEARBOX"
        case .mass:
            return "MASS"
        }
    }
    
    var isEditable: Bool {
        return false
    }
    
    var keyBoardType: UIKeyboardType {
        return .default
    }
    
    
}
