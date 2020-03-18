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
            return "dk_detection_mode_disabled_title".dkVehicleLocalized()
        case .gps :
            return "dk_detection_mode_gps_title".dkVehicleLocalized()
        case .beacon, .beacon_disabled:
            return "dk_detection_mode_beacon_title".dkVehicleLocalized()
        case .bluetooth, .bluetooth_disabled:
            return "dk_detection_mode_bluetooth_title".dkVehicleLocalized()
        }
    }
    
    func getDescription(vehicle: DKVehicle) -> NSAttributedString {
        switch self {
        case .empty:
            return "".dkAttributedString().build()
        case .disabled:
            return "dk_detection_mode_disabled_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        case .gps :
            return "dk_detection_mode_gps_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        case .beacon:
            let beaconCode = String(vehicle.beacon?.code ?? "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            let description = "dk_detection_mode_beacon_desc_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).buildWithArgs(beaconCode)
            return description
        case .beacon_disabled:
            return "dk_detection_mode_beacon_desc_not_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.warningColor).build()
        case .bluetooth:
            let bluetoothName = String(vehicle.bluetooth?.name ??  "").dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
            let description = "dk_detection_mode_bluetooth_desc_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).buildWithArgs(bluetoothName)
            return description
        case .bluetooth_disabled:
            return "dk_detection_mode_bluetooth_desc_not_configured".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.warningColor).build()
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .empty, .disabled, .gps:
            return nil
        case .beacon, .beacon_disabled:
            return "dk_vehicle_configure_beacon_title".dkVehicleLocalized().uppercased()
        case .bluetooth, .bluetooth_disabled:
            return "dk_vehicle_configure_bluetooth_title".dkVehicleLocalized().uppercased()
        }
    }
    
    var descriptionImage: UIImage? {
        switch self {
        case .beacon_disabled, .bluetooth_disabled:
            return DKImages.warning.image
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
            return "dk_detection_mode_disabled_title".dkVehicleLocalized()
        case .gps:
            return "dk_detection_mode_gps_title".dkVehicleLocalized()
        case .beacon:
            return "dk_detection_mode_beacon_title".dkVehicleLocalized()
        case .bluetooth:
            return "dk_detection_mode_bluetooth_title".dkVehicleLocalized()
        }
    }
}
