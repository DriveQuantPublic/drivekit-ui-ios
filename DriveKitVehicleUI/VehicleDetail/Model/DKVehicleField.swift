// swiftlint:disable all
//
//  VehicleField.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule
import DriveKitCommonUI

public protocol DKVehicleField {
    var isEditable: Bool { get }
    var keyBoardType: UIKeyboardType { get }
    func isDisplayable(vehicle: DKVehicle) -> Bool
    func getTitle(vehicle: DKVehicle) -> String
    func getDescription(vehicle: DKVehicle) -> String?
    func getValue(vehicle: DKVehicle) -> String?
    func isValid(value: String, vehicle: DKVehicle) -> Bool
    func getErrorDescription(value: String, vehicle: DKVehicle) -> String?
    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void)
}

enum EngineField: DKVehicleField, CaseIterable {
    case motor, consumption

    var isEditable: Bool {
        switch self {
            case .motor, .consumption:
                return false
        }
    }

    var keyBoardType: UIKeyboardType {
        return .default
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
        case .motor:
            return "dk_motor".dkVehicleLocalized()
        case .consumption:
            return "dk_consumption".dkVehicleLocalized()
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .motor:
            return DKVehicleEngineIndex(rawValue: vehicle.engineIndex)?.text()
        case .consumption:
            return vehicle.consumption.formatConsumption()
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        return true
    }

    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return nil
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}

enum GeneralField: DKVehicleField, CaseIterable {
    case name, category, brand, model, version

    var isEditable: Bool {
        switch self {
            case .name:
                return true
            case .category, .brand, .model, .version:
                return false
        }
    }

    var keyBoardType: UIKeyboardType {
        return .default
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
        case .name:
            return "dk_name".dkVehicleLocalized()
        case .category:
            return "dk_category".dkVehicleLocalized()
        case .brand:
            return "dk_brand".dkVehicleLocalized()
        case .model:
            return "dk_model".dkVehicleLocalized()
        case .version:
            return "dk_version".dkVehicleLocalized()
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .name:
            return vehicle.computeName()
        case .category:
            if let typeIndex = vehicle.typeIndex {
                let category = DKVehicleCategory(rawValue: typeIndex)
                return category?.title()
            } else {
                return " - "
            }
        case .brand:
            if let brand = vehicle.brand {
                return brand
            } else {
                return nil
            }
        case .model:
            return vehicle.model
        case .version:
            return vehicle.version
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        if self == .name {
            return value.count <= 50
        } else {
            return true
        }
    }

    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        if self == .name {
            return "dk_vehicle_field_name_error".dkVehicleLocalized()
        } else {
            return nil
        }
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void) {
        if self == .name {
            DriveKitVehicle.shared.renameVehicle(name: value, vehicleId: vehicle.vehicleId, completionHandler: { status in
                switch status {
                case .success:
                    completion(true)
                case .unknownVehicle, .error, .invalidCharacteristics, .vehicleIdAlreadyUsed, .onlyOneGpsVehicleAllowed:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            })
        } else {
            completion(true)
        }
    }
}

enum BluetoothField: DKVehicleField, CaseIterable {
    case bluetoothName, macAddress

    var isEditable: Bool {
        return false
    }

    var keyBoardType: UIKeyboardType {
        return .default
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
        case .macAddress:
            return "dk_bluetooth_address".dkVehicleLocalized()
        case .bluetoothName:
            return "dk_bluetooth_name".dkVehicleLocalized()
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .macAddress:
            return vehicle.bluetooth?.macAddress
        case .bluetoothName:
            return vehicle.bluetooth?.name
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        return true
    }

    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return nil
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}

enum BeaconField: DKVehicleField, CaseIterable {
    case uniqueId, major, minor

    var isEditable: Bool {
        return false
    }

    var keyBoardType: UIKeyboardType {
        return .default
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
        case .uniqueId:
            return "dk_beacon_code".dkVehicleLocalized()
        case .minor:
            return "dk_beacon_minor".dkVehicleLocalized()
        case .major:
            return "dk_beacon_major".dkVehicleLocalized()
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .uniqueId:
            return vehicle.beacon?.uniqueId
        case .minor:
            if let minor = vehicle.beacon?.minor {
                return String(minor)
            } else {
                return nil
            }
        case .major:
            if let major = vehicle.beacon?.major {
                return String(major)
            } else {
                return nil
            }
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        return true
    }

    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return nil
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}

enum CharacteristicsField: DKVehicleField, CaseIterable {
    case power, gearbox, mass, ptac

    var isEditable: Bool {
        return false
    }

    var keyBoardType: UIKeyboardType {
        return .default
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        if self == .power && vehicle.isTruck() {
            return false
        }
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
            case .power:
                return "dk_power".dkVehicleLocalized()
            case .gearbox:
                return "dk_gearbox".dkVehicleLocalized()
            case .mass:
                if vehicle.isTruck() {
                    return "dk_vehicle_curbweight".dkVehicleLocalized()
                } else {
                    return "dk_mass".dkVehicleLocalized()
                }
            case .ptac:
                return "dk_vehicle_ptac".dkVehicleLocalized()
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .power:
            return vehicle.power.formatPower()
        case .gearbox:
            if vehicle.isTruck() {
                return nil
            }
            let carGearBoxIndex = vehicle.gearboxIndex - 1
            switch carGearBoxIndex {
            case 0:
                return "dk_gearbox_automatic".dkVehicleLocalized()
            case 1:
                return "dk_gearbox_manual_5".dkVehicleLocalized()
            case 2:
                return "dk_gearbox_manual_6".dkVehicleLocalized()
            case 3:
                return "dk_gearbox_manual_7".dkVehicleLocalized()
            case 4:
                return "dk_gearbox_manual_8".dkVehicleLocalized()
            default:
                return nil
            }
        case .mass:
            if vehicle.isTruck() {
                return vehicle.mass.formatMassInTon()
            } else {
                return vehicle.mass.formatMass()
            }
        case .ptac:
            if vehicle.isTruck(), let ptac = vehicle.ptac {
                return ptac.formatMassInTon()
            } else {
                return nil
            }
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        return true
    }

    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return nil
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
