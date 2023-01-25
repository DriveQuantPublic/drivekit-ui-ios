// swiftlint:disable all
//
//  OdometerUtils.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 29/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

extension DriveKitVehicle {
    static func getVehicle(withId vehicleId: String) -> DKVehicle? {
        return DriveKitVehicle.shared.vehiclesQuery().whereEqualTo(field: "vehicleId", value: vehicleId).queryOne().execute()
    }

    static func getVehicles() -> [DKVehicle] {
        return DriveKitVehicle.shared.vehiclesQuery().noFilter().query().execute().sorted { $0.computeName().lowercased() < $1.computeName().lowercased() }
    }

    static func hasVehicles() -> Bool {
        return DriveKitVehicle.shared.vehiclesQuery().noFilter().queryOne().execute() != nil
    }
}
