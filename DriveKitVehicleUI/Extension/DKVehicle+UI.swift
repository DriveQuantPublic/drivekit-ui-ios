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
    
    func getDisplayName(position: Int) -> String {
        if let name = self.name, name.lowercased() != getModel().lowercased() {
            return name
        } else {
            let displayName = "dk_vehicle_my_vehicle".dkVehicleLocalized() + " - " + String(position)
            return displayName
        }
    }
    
    func getLiteConfigCategoryName() -> String {
        let categories = DKVehicleCategory.allCases
        var categoryName = ""
        for category in categories {
            if category.liteConfigDqIndex == self.dqIndex ?? "" {
                switch category {
                case .micro:
                    categoryName = "dk_vehicle_category_car_micro_title".dkVehicleLocalized()
                case .compact:
                    categoryName = "dk_vehicle_category_car_compact_title".dkVehicleLocalized()
                case .sedan:
                    categoryName = "dk_vehicle_category_car_sedan_title".dkVehicleLocalized()
                case .suv:
                    categoryName = "dk_vehicle_category_car_suv_title".dkVehicleLocalized()
                case .minivan:
                    categoryName = "dk_vehicle_category_car_minivan_title".dkVehicleLocalized()
                case .commercial:
                    categoryName = "dk_vehicle_category_car_commercial_title".dkVehicleLocalized()
                case .luxury:
                    categoryName = "dk_vehicle_category_car_luxury_title".dkVehicleLocalized()
                case .sport:
                    categoryName = "dk_vehicle_category_car_sport_title".dkVehicleLocalized()
                }
            }
        }
        return categoryName
    }
    
    /*var displayName : String {
        return name ?? defaultName
    }*/
    
    func getVehicleImage() -> UIImage? {
        let vehicleImage = "DQ_vehicle_" + self.vehicleId
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(vehicleImage).jpeg")
        var image = UIImage(named: "dk_vehicle_default", in: Bundle.vehicleUIBundle, compatibleWith: nil)
               do {
                   let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                   for file in files {
                       if "\(documentPath)/\(file)" == filePath.path {
                           image = UIImage(contentsOfFile: filePath.path)
                       }
                   }
               } catch {
                   print("Could not add image from document directory: \(error)")
               }

       return image
    }
    
    
    var detectionModeDescription :  NSAttributedString {
        switch self.detectionMode {
        case .disabled:
            return "dk_detection_mode_disabled_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        case .gps :
            return "dk_detection_mode_gps_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        case .beacon:
            if beacon != nil {
                let beaconCode = String(beacon?.uniqueId ?? "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
                let description = "dk_detection_mode_beacon_desc_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).buildWithArgs(beaconCode)
                return description
            }else {
                return "dk_detection_mode_beacon_desc_not_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.criticalColor).build()
            }
        case .bluetooth:
            if bluetooth != nil {
                let bluetoothName = String(bluetooth?.name ??  "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
                let description = "dk_detection_mode_bluetooth_desc_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).buildWithArgs(bluetoothName)
                return description
            }else{
                return "dk_detection_mode_bluetooth_desc_not_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.criticalColor).build()
            }
        case .none:
            return "".dkAttributedString().build()
        }
    }
}
