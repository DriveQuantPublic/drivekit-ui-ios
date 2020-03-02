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


enum EventType {
    case adherence, brake, acceleration, lock, unlock, end, start
    
    func getImageID() -> String {
        switch self {
        case .adherence:
            return "dk_safety_adherence"
        case .brake:
            return "dk_safety_decel"
        case .acceleration:
            return "dk_safety_accel"
        case .lock:
            return "dk_lock_event"
        case .unlock:
            return "dk_unlock_event"
        case .end:
            return "dk_end_event_black"
        case .start:
            return "dk_start_event_black"
        }
    }
    
    func name() -> String {
        switch self {
        case .adherence:
            return "dk_safety_adherence".dkDriverDataLocalized()
        case .brake:
            return "dk_safety_decel".dkDriverDataLocalized()
        case .acceleration:
            return "dk_safety_accel".dkDriverDataLocalized()
        case .lock:
            return "dk_lock_event".dkDriverDataLocalized()
        case .unlock:
            return "dk_unlock_event".dkDriverDataLocalized()
        case .end:
            return "dk_end_event".dkDriverDataLocalized()
        case .start:
            return "dk_start_event".dkDriverDataLocalized()
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
            return isHigh ? "dk_safety_list_adherence_critical".dkDriverDataLocalized() : "dk_safety_list_adherence".dkDriverDataLocalized()
        case .acceleration:
            return isHigh ? "dk_safety_list_acceleration_critical".dkDriverDataLocalized() : "dk_safety_acceleration".dkDriverDataLocalized()
        case .brake:
            return isHigh ? "dk_safety_list_brake_critical".dkDriverDataLocalized() : "dk_safety_brake".dkDriverDataLocalized()
        case .start:
            return "dk_start_event".dkDriverDataLocalized()
        case .end:
            return "dk_end_event".dkDriverDataLocalized()
        case .unlock:
            return "dk_unlock_event".dkDriverDataLocalized()
        case .lock:
            return "dk_lock_event".dkDriverDataLocalized()
        }
    }
    
    func getExplanation() -> String{
        switch type {
        case .adherence:
            return isHigh ? "dk_safety_explain_adherence_critical".dkDriverDataLocalized() : "dk_safety_explain_adherence".dkDriverDataLocalized()
        case .acceleration:
            return isHigh ? "dk_safety_explain_acceleration_critical".dkDriverDataLocalized() : "dk_safety_explain_acceleration".dkDriverDataLocalized()
        case .brake:
            return isHigh ? "dk_safety_explain_brake_critical".dkDriverDataLocalized() : "dk_safety_explain_brake".dkDriverDataLocalized()
        case .start:
            return ""
        case .end:
            return ""
        case .unlock:
            return "dk_screen_unlock_text".dkDriverDataLocalized()
        case .lock:
            return "dk_screen_lock_text".dkDriverDataLocalized()
        }
    }
}
