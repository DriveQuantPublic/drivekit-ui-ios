//
//  DKDetectionMode+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 02/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

extension DKDetectionMode {
    
    var title: String {
        switch self {
        case .disabled:
            return "dk_detection_mode_disabled_title".dkVehicleLocalized()
        case .gps :
            return "dk_detection_mode_gps_title".dkVehicleLocalized()
        case .beacon:
            return "dk_detection_mode_beacon_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_detection_mode_bluetooth_title".dkVehicleLocalized()
        }
    }
}
