//
//  Event.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverDataModule
import CoreLocation
import DriveKitCommonUI


enum EventType {
    case adherence, brake, acceleration, lock, unlock, pickUp, hangUp, end, start
    
    func getImage() -> UIImage? {
        switch self {
        case .adherence:
            return DKImages.safetyAdherence.image
        case .brake:
            return DKImages.safetyDecel.image
        case .acceleration:
            return DKImages.safetyAccel.image
        case .lock:
            return DKDriverDataImages.lockEvent.image?.withRenderingMode(.alwaysTemplate)
        case .unlock:
            return DKDriverDataImages.unlockEvent.image?.withRenderingMode(.alwaysTemplate)
        case .pickUp:
            return DKImages.call.image?.withRenderingMode(.alwaysTemplate)
        case .hangUp:
            return DKDriverDataImages.endCall.image?.withRenderingMode(.alwaysTemplate)
        case .end:
            return DKDriverDataImages.arrival.image?.withRenderingMode(.alwaysTemplate)
        case .start:
            return DKDriverDataImages.departure.image?.withRenderingMode(.alwaysTemplate)
        }
    }
}


public class TripEvent {
    let type: EventType
    let date: Date
    let position: CLLocationCoordinate2D
    let isHigh: Bool
    let value: Double
    let isForbidden: Bool

    init(type: EventType, date: Date, position: CLLocationCoordinate2D, value: Double, isHigh: Bool = false, isForbidden: Bool = false) {
        self.type = type
        self.date = date
        self.position = position
        self.value = value
        self.isHigh = isHigh
        self.isForbidden = isForbidden
    }
    
    func getMapImage() -> DKDriverDataImages {
        switch type {
        case .adherence:
            return isHigh ? DKDriverDataImages.mapAdhHigh : DKDriverDataImages.mapAdh
        case .acceleration:
            return isHigh ? DKDriverDataImages.mapAccelHigh : DKDriverDataImages.mapAccel
        case .brake:
            return isHigh ? DKDriverDataImages.mapDecelHigh : DKDriverDataImages.mapDecel
        case .start:
            return DKDriverDataImages.mapDeparture
        case .end:
            return DKDriverDataImages.mapArrival
        case .unlock:
            return DKDriverDataImages.mapUnlock
        case .lock:
            return DKDriverDataImages.mapLock
        case .pickUp:
            return DKDriverDataImages.mapBeginCall
        case .hangUp:
            return DKDriverDataImages.mapEndCall
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
        case .unlock, .lock, .start, .end, .pickUp, .hangUp:
            return 0
        }
    }

    func getTitle() -> String {
        switch type {
        case .adherence:
            return isHigh ? "dk_driverdata_safety_list_adherence_critical".dkDriverDataLocalized() : "dk_driverdata_safety_list_adherence".dkDriverDataLocalized()
        case .acceleration:
            return isHigh ? "dk_driverdata_safety_list_acceleration_critical".dkDriverDataLocalized() : DKCommonLocalizable.ecodrivingAccelerationStrong.text()
        case .brake:
            return isHigh ? "dk_driverdata_safety_list_brake_critical".dkDriverDataLocalized() : DKCommonLocalizable.ecodrivingDecelerationStrong.text()
        case .start:
            return "dk_driverdata_start_event".dkDriverDataLocalized()
        case .end:
            return "dk_driverdata_end_event".dkDriverDataLocalized()
        case .unlock:
            return "dk_driverdata_unlock_event".dkDriverDataLocalized()
        case .lock:
            return "dk_driverdata_lock_event".dkDriverDataLocalized()
        case .pickUp:
            return isForbidden ? "dk_driverdata_beginning_unauthorized_call".dkDriverDataLocalized() : "dk_driverdata_beginning_authorized_call".dkDriverDataLocalized()
        case .hangUp:
            return isForbidden ? "dk_driverdata_end_unauthorized_call".dkDriverDataLocalized() : "dk_driverdata_end_authorized_call".dkDriverDataLocalized()
        }
    }

    func getExplanation() -> String {
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
        case .pickUp:
            return isForbidden ? "dk_driverdata_beginning_unauthorized_call_info_content".dkDriverDataLocalized() : "dk_driverdata_beginning_authorized_call_info_content".dkDriverDataLocalized()
        case .hangUp:
            return isForbidden ? "dk_driverdata_end_unauthorized_call_info_content".dkDriverDataLocalized() : "dk_driverdata_end_authorized_call_info_content".dkDriverDataLocalized()
        }
    }
}
