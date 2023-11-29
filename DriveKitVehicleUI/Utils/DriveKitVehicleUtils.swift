// swiftlint:disable convenience_type
//
//  DriveKitVehicleUtils.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 05/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule

public class DriveKitVehicleUtils {
    public static func getBestDetectionModeForNewVehicle(vehicleList: [DKVehicle]? = nil) -> DKDetectionMode {
        let detectionModes = DriveKitVehicleUI.shared.detectionModes
        if detectionModes.isEmpty {
            return .disabled
        } else if detectionModes.contains(.gps) {
            let vehicles: [DKVehicle]
            if let vehicleList = vehicleList {
                vehicles = vehicleList
            } else {
                vehicles = DriveKitDBVehicleAccess.shared.findVehiclesOrderByNameAsc().execute()
            }
            let vehiclesGPS = vehicles.filter { $0.detectionMode ?? .disabled == DKDetectionMode.gps }
            if vehiclesGPS.isEmpty {
                return .gps
            } else {
                return detectionModes.first { $0 != .gps } ?? .disabled
            }
        } else {
            return detectionModes[0]
        }
    }
}
