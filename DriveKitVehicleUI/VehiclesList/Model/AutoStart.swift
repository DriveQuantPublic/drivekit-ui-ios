//
//  AutoStart.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBVehicleAccess
import DriveKitCommonUI

enum AutoStart {
    case empty, disabled, gps, beacon, beacon_disabled, bluetooth, bluetooth_disabled
    
    var detectionModeValue : DKDetectionMode? {
        switch self {
        case .empty:
            return nil
        case .disabled:
            return .disabled
        case .gps :
            return .gps
        case .beacon, .beacon_disabled:
            return .beacon
        case .bluetooth, .bluetooth_disabled:
            return .bluetooth
        }
    }
    
    var title: String {
        switch self {
        case .empty:
            return ""
        case .disabled:
            return "dk_disabled_detection_mode_title".dkVehicleLocalized()
        case .gps :
            return "dk_gps_detection_mode_title".dkVehicleLocalized()
        case .beacon:
            return "dk_beacon_detection_mode_title".dkVehicleLocalized()
        case .beacon_disabled:
            return "dk_beacon_disabled_detection_mode_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_bluetooth_detection_mode_title".dkVehicleLocalized()
        case .bluetooth_disabled:
            return "dk_bluetooth_disabled_detection_mode_title".dkVehicleLocalized()
        }
    }
    
    var description: String {
        switch self {
        case .empty:
            return ""
        case .disabled:
            return "dk_detection_mode_disabled_desc".dkVehicleLocalized()
        case .gps :
            return "dk_detection_mode_gps_desc".dkVehicleLocalized()
        case .beacon:
            return "dk_detection_mode_beacon_desc_configured".dkVehicleLocalized()
        case .beacon_disabled:
            return "dk_detection_mode_beacon_desc_not_configured".dkVehicleLocalized()
        case .bluetooth:
            return "dk_detection_mode_bluetooth_desc_configured".dkVehicleLocalized()
        case .bluetooth_disabled:
            return "dk_detection_mode_bluetooth_desc_not_configured".dkVehicleLocalized()
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .empty, .disabled, .gps:
            return nil
        case .beacon, .beacon_disabled:
            return "dk_vehicle_configure_beacon_desc".dkVehicleLocalized()
        case .bluetooth, .bluetooth_disabled:
            return "dk_vehicle_configure_bluetooth_desc".dkVehicleLocalized()
        }
    }
    
    var descriptionImage: UIImage? {
        switch self {
        case .beacon_disabled, .bluetooth_disabled:
            return UIImage(named: "dk_warning", in: .vehicleUIBundle, compatibleWith: nil)
        case .empty, .disabled, .gps, .bluetooth, .beacon:
            return nil
        }
    }
}

extension DKDetectionMode {
    func alertAction(completionHandler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let detectionAction = UIAlertAction(title: self.title(), style: .default, handler: completionHandler)
        return detectionAction
    }
    
    func title() -> String {
        switch (self) {
        case .disabled:
            return "dk_disabled_detection_mode_title".dkVehicleLocalized()
        case .gps:
            return "dk_gps_detection_mode_title".dkVehicleLocalized()
        case .beacon:
            return "dk_beacon_detection_mode_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_bluetooth_detection_mode_title".dkVehicleLocalized()
        }
    }
}
