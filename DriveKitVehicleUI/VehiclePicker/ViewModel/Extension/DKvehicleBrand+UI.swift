//
//  DKvehicleBrand+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitVehicle

extension DKVehicleBrand : VehiclePickerCollectionViewItem {
    
    func title() -> String {
        return self.name
    }
    
    func image() -> UIImage? {
        switch self {
        case .alpha_romeo:
            return UIImage(named: "dk_alpha_romeo", in: .vehicleUIBundle, compatibleWith: nil)
        case .audi:
            return UIImage(named: "dk_audi", in: .vehicleUIBundle, compatibleWith: nil)
        case .bmw:
            return UIImage(named: "dk_bmw", in: .vehicleUIBundle, compatibleWith: nil)
        case .citroen:
            return UIImage(named: "dk_citroen", in: .vehicleUIBundle, compatibleWith: nil)
        case .dacia:
            return UIImage(named: "dk_dacia", in: .vehicleUIBundle, compatibleWith: nil)
        case .fiat:
            return UIImage(named: "dk_fiat", in: .vehicleUIBundle, compatibleWith: nil)
        case .ford:
            return UIImage(named: "dk_ford", in: .vehicleUIBundle, compatibleWith: nil)
        case .hyundai:
            return UIImage(named: "dk_hyundai", in: .vehicleUIBundle, compatibleWith: nil)
        case .kia:
            return UIImage(named: "dk_kia", in: .vehicleUIBundle, compatibleWith: nil)
        case .mercedes:
            return UIImage(named: "dk_mercedes", in: .vehicleUIBundle, compatibleWith: nil)
        case .mini:
            return UIImage(named: "dk_mini", in: .vehicleUIBundle, compatibleWith: nil)
        case .nissan:
            return UIImage(named: "dk_nissan", in: .vehicleUIBundle, compatibleWith: nil)
        case .opel:
            return UIImage(named: "dk_opel", in: .vehicleUIBundle, compatibleWith: nil)
        case .renault:
            return UIImage(named: "dk_renault", in: .vehicleUIBundle, compatibleWith: nil)
        case .seat:
            return UIImage(named: "dk_seat", in: .vehicleUIBundle, compatibleWith: nil)
        case .skoda:
            return UIImage(named: "dk_skoda", in: .vehicleUIBundle, compatibleWith: nil)
        case .toyota:
            return UIImage(named: "dk_toyota", in: .vehicleUIBundle, compatibleWith: nil)
        case .volkswagen:
            return UIImage(named: "dk_volkswagen", in: .vehicleUIBundle, compatibleWith: nil)
        case .volvo:
            return UIImage(named: "dk_volvo", in: .vehicleUIBundle, compatibleWith: nil)
        case .peugeot:
            return UIImage(named: "dk_peugeot", in: .vehicleUIBundle, compatibleWith: nil)
        default:
            return nil
        }
    }
    
    func hasImage() -> Bool {
        switch self {
        default:
            return image() != nil
        }
    }
    
}

extension DKVehicleBrand : VehiclePickerTableViewItem {
    func text() -> String {
        return self.name
    }
}

class OtherVehicles : VehiclePickerCollectionViewItem {
    func title() -> String {
        return "dk_vehicle_other_brands".dkVehicleLocalized()
    }
    
    func image() -> UIImage? {
        return nil
    }
    
    
}
