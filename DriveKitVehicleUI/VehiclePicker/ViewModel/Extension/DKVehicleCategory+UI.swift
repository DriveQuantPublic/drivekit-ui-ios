//
//  DKVehicleCategory+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 08/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle

extension DKVehicleCategory : VehiclePickerCollectionViewItem {
    func title() -> String {
        switch self {
        case .micro:
            return "micro"
        case .compact:
            return "compact"
        case .sedan:
            return "sedan"
        case .suv:
            return "suv"
        case .minivan:
            return "minivan"
        case .commercial:
            return "commercial"
        case .luxury:
            return "luxury"
        case .sport:
            return "sport"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .micro:
            return UIImage(named: "dk_icon_micro", in: .vehicleUIBundle, compatibleWith: nil)
        case .compact:
            return UIImage(named: "dk_icon_compact", in: .vehicleUIBundle, compatibleWith: nil)
        case .sedan:
            return UIImage(named: "dk_icon_sedan", in: .vehicleUIBundle, compatibleWith: nil)
        case .suv:
            return UIImage(named: "dk_icon_suv", in: .vehicleUIBundle, compatibleWith: nil)
        case .minivan:
            return UIImage(named: "dk_icon_minivan", in: .vehicleUIBundle, compatibleWith: nil)
        case .commercial:
            return UIImage(named: "dk_icon_commercial", in: .vehicleUIBundle, compatibleWith: nil)
        case .luxury:
            return UIImage(named: "dk_icon_luxury", in: .vehicleUIBundle, compatibleWith: nil)
        case .sport:
            return UIImage(named: "dk_icon_sport", in: .vehicleUIBundle, compatibleWith: nil)
        }
    }
    
    
}
