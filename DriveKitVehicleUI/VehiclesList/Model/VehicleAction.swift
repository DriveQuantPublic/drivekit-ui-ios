//
//  VehicleOption.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccess

public enum VehicleAction : String, CaseIterable  {
    case show
    case rename
    case replace
    case delete
    
    func title() -> String {
        switch (self) {
        case .delete:
            return "dk_vehicle_delete".dkVehicleLocalized()
        case .replace:
            return "dk_vehicle_replace".dkVehicleLocalized()
        case .show:
            return "dk_vehicle_show".dkVehicleLocalized()
        case .rename:
            return "dk_vehicle_rename".dkVehicleLocalized()
        }
    }
    
    func alertAction(completionHandler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let optionAction = UIAlertAction(title: self.title(), style: .default, handler: completionHandler)
        return optionAction
    }
    
}

enum DeleteAlertType : String {
    case vehicle
    case bluetooth
    case beacon
}
