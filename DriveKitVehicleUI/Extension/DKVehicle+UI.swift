//
//  DKVehicle+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitVehicle

extension DKVehicle {
    var defaultName: String {
        if self.liteConfig {
            return getCategoryName()
        } else {
            return String(format: "%@ %@ %@", self.brand ?? "", self.model ?? "", self.version ?? "")
        }
    }
    
    func getModel() -> String {
        return String(format: "%@ %@ %@", self.brand ?? "", self.model ?? "", self.version ?? "")
    }
    
    func getPosition(vehiclesList: [DKVehicle]) -> Int {
        if let index = vehiclesList.firstIndex(of: self) {
            return index + 1
        } else {
            return 1
        }
    }
    
    func getDisplayNameInList(vehiclesList: [DKVehicle]) -> String {
        let position = getPosition(vehiclesList: vehiclesList)
        let displayName = "dk_vehicle_my_vehicle".dkVehicleLocalized() + " - " + String(position)
        if let name = self.name, name != defaultName {
            return name
        } else {
            return displayName
        }
    }
    
    func getCategoryName() -> String {
        let categories = DKVehicleCategory.allCases
        var categoryName = ""
        for category in categories {
            if category.liteConfigDqIndex == self.dqIndex ?? "" {
                switch category {
                case .micro:
                    categoryName = "dk_vehicle_category_car_micro_title"
                case .compact:
                    categoryName = "dk_vehicle_category_car_compact_title"
                case .sedan:
                    categoryName = "dk_vehicle_category_car_sedan_title"
                case .suv:
                    categoryName = "dk_vehicle_category_car_suv_title"
                case .minivan:
                    categoryName = "dk_vehicle_category_car_minivan_title"
                case .commercial:
                    categoryName = "dk_vehicle_category_car_commercial_title"
                case .luxury:
                    categoryName = "dk_vehicle_category_car_luxury_title"
                case .sport:
                    categoryName = "dk_vehicle_category_car_sport_title"
                }
            }
        }
        return categoryName
    }
    
    var displayName : String {
        return name ?? defaultName
    }
}
