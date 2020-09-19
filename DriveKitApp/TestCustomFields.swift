//
//  TestCustomFields.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 25/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitVehicleUI
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

enum TestField : DKVehicleField {
    case number, ascii

    var isEditable: Bool {
        return true
    }

    var keyBoardType: UIKeyboardType {
        switch self {
            case .number:
                return .numberPad
            case .ascii:
                return .asciiCapableNumberPad
        }
    }

    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return getValue(vehicle: vehicle) != nil
    }

    func getTitle(vehicle: DKVehicle) -> String {
        switch self {
        case .number:
            return "Test Field Number"
        case .ascii:
            return "Test Field ASCII"
        }
    }

    func getDescription(vehicle: DKVehicle) -> String? {
        return nil
    }

    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .number:
           return String(vehicle.consumption)
        case .ascii:
            return vehicle.brand
        }
    }

    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        return value.count < 5
    }
    
    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return nil
    }

    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: (Bool) -> ()) {
        print("test extra field")
        completion(true)
    }
}
