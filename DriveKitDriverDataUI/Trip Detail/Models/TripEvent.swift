//
//  Event.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData
import CoreLocation
import DriveKitCommonUI


enum EventType {
    case adherence, brake, acceleration, lock, unlock, end, start
    
    func getImage() -> UIImage? {
        switch self {
        case .adherence:
            return DKImages.safetyAdherence.image
        case .brake:
            return DKImages.safetyDecel.image
        case .acceleration:
            return DKImages.safetyAccel.image
        case .lock:
            return UIImage(named: "dk_lock_event", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .unlock:
            return UIImage(named: "dk_unlock_event", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .end:
            return UIImage(named: "dk_end_event_black", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .start:
            return UIImage(named: "dk_start_event_black", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func name() -> String {
        switch self {
        case .adherence:
            return "dk_driverdata_safety_adherence".dkDriverDataLocalized()
        case .brake:
            return "dk_driverdata_safety_decel".dkDriverDataLocalized()
        case .acceleration:
            return "dk_driverdata_safety_accel".dkDriverDataLocalized()
        case .lock:
            return "dk_driverdata_lock_event".dkDriverDataLocalized()
        case .unlock:
            return "dk_driverdata_unlock_event".dkDriverDataLocalized()
        case .end:
            return "dk_driverdata_end_event".dkDriverDataLocalized()
        case .start:
            return "dk_driverdata_start_event".dkDriverDataLocalized()
        }
    }
}


class TripEvent {
    var type: EventType
    var date : Date
    var position: CLLocationCoordinate2D
    var isHigh: Bool
    var value: Double
    
    init(type: EventType, date: Date, position: CLLocationCoordinate2D, value: Double, isHigh: Bool = false) {
        self.type = type
        self.date = date
        self.position = position
        self.value = value
        self.isHigh = isHigh
    }
    
    func getMapImageID() -> String {
        switch type {
        case .adherence:
            return isHigh ? "dk_map_adh_high" : "dk_map_adh"
        case .acceleration:
            return isHigh ? "dk_map_accel_high" : "dk_map_accel"
        case .brake:
            return isHigh ? "dk_map_decel_high" : "dk_map_decel"
        case .start:
            return "dk_map_start_event"
        case .end:
            return "dk_map_end_event"
        case .unlock:
            return "dk_map_unlock"
        case .lock:
            return "dk_map_lock"
        }
    }
    
    func getZIndex() -> Int32 {
        switch type {
        case .adherence:
            return isHigh ? 750 : 250
        case .brake:
            return isHigh ? 999 : 500
        case .acceleration:
            return isHigh ? 999 : 500
        case .unlock, .lock, .start, .end:
            return 0
        }
    }
    
    func getTitle() -> String{
        switch type {
        case .adherence:
            return isHigh ? "dk_driverdata_safety_list_adherence_critical".dkDriverDataLocalized() : "dk_driverdata_safety_list_adherence".dkDriverDataLocalized()
        case .acceleration:
            return isHigh ? "dk_driverdata_safety_list_acceleration_critical".dkDriverDataLocalized() : "dk_driverdata_safety_accel".dkDriverDataLocalized()
        case .brake:
            return isHigh ? "dk_driverdata_safety_list_brake_critical".dkDriverDataLocalized() : "dk_driverdata_safety_decel".dkDriverDataLocalized()
        case .start:
            return "dk_driverdata_start_event".dkDriverDataLocalized()
        case .end:
            return "dk_driverdata_end_event".dkDriverDataLocalized()
        case .unlock:
            return "dk_driverdata_unlock_event".dkDriverDataLocalized()
        case .lock:
            return "dk_driverdata_lock_event".dkDriverDataLocalized()
        }
    }
    
    func getExplanation() -> String{
        switch type {
        case .adherence:
            return isHigh ? "dk_driverdata_safety_explain_adherence_critical".dkDriverDataLocalized() : "dk_driverdata_safety_explain_adherence".dkDriverDataLocalized()
        case .acceleration:
            return isHigh ? "dk_driverdata_safety_explain_acceleration_critical".dkDriverDataLocalized() : "dk_driverdata_safety_explain_acceleration".dkDriverDataLocalized()
        case .brake:
            return isHigh ? "dk_driverdata_safety_explain_brake_critical".dkDriverDataLocalized() : "dk_driverdata_safety_explain_brake".dkDriverDataLocalized()
        case .start:
            return ""
        case .end:
            return ""
        case .unlock:
            return "dk_driverdata_screen_unlock_text".dkDriverDataLocalized()
        case .lock:
            return "dk_driverdata_screen_lock_text".dkDriverDataLocalized()
        }
    }
}
