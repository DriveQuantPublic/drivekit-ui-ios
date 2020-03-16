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

public class DriveKitVehicleUI {
    
    public static let shared = DriveKitVehicleUI()
    
    var vehicleTypes : [DKVehicleType] = [.car]
    var brands : [DKVehicleBrand] = DKVehicleBrand.allCases
    var categoryConfigType : DKCategoryConfigType = .bothConfig
    var vehicleEngineIndexes : [DKVehicleEngineIndex] = DKVehicleEngineIndex.allCases
    var brandsWithIcons : Bool = true
    
    var canAddVehicle: Bool = true
    var maxVehicles: Int? = nil
    
    var vehicleActions : [VehicleAction] = VehicleAction.allCases
    
    
    var enableReplaceVehicles : Bool = true
    var enableDeleteVehicles: Bool = true
    var enableRenameVehicles: Bool = true
    var displayVehicleDetails: Bool = true
    
    
    var detectionModes: [DKDetectionMode] = [.disabled, .gps, .beacon, .bluetooth]
    
    private init() {}
    
    public func initialize() {
        // TODO : register to navigation controller
    }
    
    public func configureVehicleTypes(types: [DKVehicleType]){
        if !types.isEmpty {
            self.vehicleTypes = types
        }
    }
    
    public func configureBrands(brands : [DKVehicleBrand]) {
        if !brands.isEmpty {
            self.brands = brands
        }
    }
    
    public func configureCategoryConfigType(type : DKCategoryConfigType) {
        self.categoryConfigType = type
    }
    
    public func configureEngineIndexes(engineIndexes: [DKVehicleEngineIndex]) {
        if !engineIndexes.isEmpty {
            self.vehicleEngineIndexes = engineIndexes
        }
    }

    public func showBrandsWithIcons(show : Bool) {
        self.brandsWithIcons = show
    }
    
    public func enableAddVehicle(enable: Bool) {
        self.canAddVehicle = enable
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
    
    public func configureMaxVehicles(max: Int?) {
        self.maxVehicles = max
    }
    
    public func configureDetectionModes(detectionModes: [DKDetectionMode]) {
        if !detectionModes.isEmpty {
            self.detectionModes = detectionModes
        }
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
