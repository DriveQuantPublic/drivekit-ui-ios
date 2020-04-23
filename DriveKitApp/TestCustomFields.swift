//
//  TestCustomFields.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 25/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitVehicleUI
import DriveKitDBVehicleAccess
import DriveKitVehicle

enum TestField : DKVehicleField {
    
    
    case number, ascii
    
    var title: String {
        switch self {
        case .number:
            return "Test Field Number"
        case .ascii:
            return "Test Field ASCII"
        }
    }
    
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
    
    func getValue(vehicle: DKVehicle) -> String? {
        switch self {
        case .number:
           return String(vehicle.consumption)
        case .ascii:
            return vehicle.brand
        }
    }
    
    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: (Bool) -> ()) {
        print("test extra field")
        completion(true)
    }
    
    func isValid(value: String) -> Bool {
        return value.count < 5
    }
    
    func getErrorDescription() -> String? {
        return nil
    }
}
