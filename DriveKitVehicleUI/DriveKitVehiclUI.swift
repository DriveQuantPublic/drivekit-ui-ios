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
import DriveKitDBVehicleAccess

public class DriveKitVehiculeUI {
    
    public static let shared = DriveKitVehiculeUI()
    
    var vehicleTypes : [DKVehicleType] = [.car]
    var brands : [DKVehicleBrand] = DKVehicleBrand.allCases
    var categoryType : DKCategoryType = .bothConfig
    var brandsWithIcons : Bool = true
    
    var enableAddVehicles: Bool = true
    var enableReplaceVehicles : Bool = true
    var enableDeleteVehicles: Bool = true
    var enableRenameVehicles: Bool = true
    var displayVehicleDetails: Bool = true
    
    var maxVehicles: Int = -1
    var detectionModes: [DKDetectionMode] = [.disabled, .gps, .beacon, .bluetooth]
    
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
    
    public func configureBrands(brands : [DKVehicleBrand]) {
        if brands.isEmpty {
            fatalError("At least 1 brand must be configured")
        }
        self.brands = brands
    }
    
    public func configureCategoryType(type : DKCategoryType) {
        self.categoryType = type
    }
    
    public func showBrandsWithIcons(show : Bool) {
        self.brandsWithIcons = show
    }
    
    public func enableAddVehicles(enable: Bool) {
        self.enableAddVehicles = enable
    }
    
    public func enableReplaceVehicles(enable: Bool) {
        self.enableReplaceVehicles = enable
    }
    
    public func enableDeleteVehicles(enable: Bool) {
        self.enableDeleteVehicles = enable
    }
    
    public func enableRenameVehicles(enable: Bool) {
        self.enableRenameVehicles = enable
    }
    
    public func displayVehicleDetails(enable: Bool) {
        self.displayVehicleDetails = enable
    }
    
    public func setMaxVehicles(max: Int) {
        self.maxVehicles = max
    }
    
    public func configureDetectionModes(detectionModes: [DKDetectionMode]) {
        self.detectionModes = detectionModes
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
