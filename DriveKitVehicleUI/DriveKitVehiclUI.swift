//
//  DriveKitVehiclUI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 07/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitVehicle

public class DriveKitVehiculeUI {
    
    public static let shared = DriveKitVehiculeUI()
    
    var vehicleTypes : [DKVehicleType] = [.car]
    var liteConfig : Bool = true
    
    private init() {}
    
    public func initialize() {
        // TODO : register to navigation controller
    }
    
    public func configureVehicleType(types: [DKVehicleType]){
        if types.isEmpty {
            fatalError("At least 1 VehicleType must be configured")
        }
        self.vehicleTypes = types
    }
    
    public func configureLiteConfig(enable: Bool) {
        self.liteConfig = enable
    }
}

extension Bundle {
    static let vehicleUIBundle = Bundle(identifier: "com.drivequant.drivekit-vehicle-ui")
}

extension String {
    public func dkVehicleLocalized() -> String {
        return self.dkLocalized(tableName: "DKVehicleLocalizable", bundle: Bundle.vehicleUIBundle ?? .main)
    }
}
