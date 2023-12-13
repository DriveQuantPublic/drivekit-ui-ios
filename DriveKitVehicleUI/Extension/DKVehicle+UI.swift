// swiftlint:disable no_magic_numbers cyclomatic_complexity
//
//  DKVehicle+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule
import DriveKitCommonUI

extension Array where Element: DKVehicle {
    func sortByDisplayNames() -> [DKVehicle] {
        return self.sorted {
            $0.getDisplayName(position: $0.getPosition(vehiclesList: self)).lowercased() < $1.getDisplayName(position: $0.getPosition(vehiclesList: self)).lowercased()
        }
    }
}

extension DKVehicle {

    func getModel() -> String {
        return String(format: "%@ %@ %@", self.brand ?? "", self.model ?? "", self.version ?? "")
    }

    func getPosition(vehiclesList: [DKVehicle]) -> Int {
        if let index = vehiclesList.firstIndex(where: {$0.vehicleId == self.vehicleId}) {
            return index
        } else {
            return 0
        }
    }

    func getDisplayName(position: Int) -> String {
        if let name = self.name, name.lowercased() != getModel().lowercased() {
            return name
        } else {
            let displayName = "dk_vehicle_my_vehicle".dkVehicleLocalized() + " - " + String(position + 1)
            return displayName
        }
    }

    public func computeName() -> String {
        return getDisplayName(position: getPosition(vehiclesList: DriveKitDBVehicleAccess.shared.findVehiclesOrderByNameAsc().execute().sortByDisplayNames()))
    }

    func getLiteConfigCategoryName() -> String {
        let categories = DKVehicleCategory.allCases
        var categoryName = ""
        for category in categories where category.getLiteConfigDqIndex(isElectric: false) == self.dqIndex ?? "" {
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
            case .twoAxlesStraightTruck, .threeAxlesStraightTruck, .fourAxlesStraightTruck, .twoAxlesTractor, .threeAxlesTractor, .fourAxlesTractor:
                categoryName = ""
            @unknown default:
                categoryName = ""
            }
    }
        return categoryName
    }

    var vehicleImageTag: String {
        return "DQ_vehicle_" + self.vehicleId
    }

    func getVehicleImage() -> UIImage? {
        let vehicleImage = vehicleImageTag
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(vehicleImage).jpeg")
        var image: UIImage?
        if self.isTruck() {
            image = DKVehicleImages.defaultTruck.image
        } else {
            image = DKVehicleImages.defaultCar.image
        }
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files where "\(documentPath)/\(file)" == filePath.path {
                image = UIImage(contentsOfFile: filePath.path)
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        return image
    }

    var detectionModeDescription: NSAttributedString {
        switch self.detectionMode {
        case .disabled:
            return "dk_detection_mode_disabled_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        case .gps: 
            return "dk_detection_mode_gps_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        case .beacon:
            if beacon != nil {
                let beaconCode = String(beacon?.uniqueId ?? "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.complementaryFontColor).build()
                let description = "dk_detection_mode_beacon_desc_configured"
                    .dkVehicleLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .smallText)
                    .color(.complementaryFontColor)
                    .buildWithArgs(beaconCode)
                return description
            } else {
                return "dk_detection_mode_beacon_desc_not_configured"
                    .dkVehicleLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: DKStyle(size: 13, traits: .traitBold))
                    .color(.criticalColor)
                    .build()
            }
        case .bluetooth:
            if bluetooth != nil {
                let bluetoothName = String(bluetooth?.name ?? "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.complementaryFontColor).build()
                let description = "dk_detection_mode_bluetooth_desc_configured"
                    .dkVehicleLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .smallText)
                    .color(.complementaryFontColor)
                    .buildWithArgs(bluetoothName)
                return description
            } else {
                return "dk_detection_mode_bluetooth_desc_not_configured"
                    .dkVehicleLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: DKStyle(size: 13, traits: .traitBold))
                    .color(.criticalColor)
                    .build()
            }
        case .none:
            return "".dkAttributedString().build()
        @unknown default:
            return "".dkAttributedString().build()
        }
    }

    var detectionModeConfigurationButton: String? {
        switch self.detectionMode {
        case .disabled, .gps, .none:
            return nil
        case .beacon:
            return "dk_vehicle_configure_beacon_title".dkVehicleLocalized().uppercased()
        case .bluetooth:
            return "dk_vehicle_configure_bluetooth_title".dkVehicleLocalized().uppercased()
        @unknown default:
            return nil
        }
    }

    var descriptionImage: UIImage? {
        if (self.detectionMode == .beacon && self.beacon == nil) || (self.detectionMode == .bluetooth && self.bluetooth == nil) {
            return DKImages.warning.image
        } else {
            return nil
        }
    }
}

extension DKVehicle: DKFilterItem {
    public func getImage() -> UIImage? {
        return self.getVehicleImage()
    }
    
    public func getName() -> String {
        return self.computeName()
    }
    
    public func getId() -> Any? {
        return self.vehicleId
    }
    
}
