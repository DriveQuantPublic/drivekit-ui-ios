//
//  DKBeacon+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import DriveKitBeaconUtilsModule
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

extension DKBeacon {    
    func toCLBeaconIdentityConstraint(noMajorMinor: Bool) -> CLBeaconIdentityConstraint {
        let uuid = UUID(uuidString: self.proximityUuid)!
        let constraint: CLBeaconIdentityConstraint
        if !noMajorMinor && self.major >= 0 {
            if self.minor >= 0 {
                constraint = CLBeaconIdentityConstraint(uuid: uuid, major: CLBeaconMajorValue(self.major), minor: CLBeaconMinorValue(self.minor))
            } else {
                constraint = CLBeaconIdentityConstraint(uuid: uuid, major: CLBeaconMajorValue(self.major))
            }
        } else {
            constraint = CLBeaconIdentityConstraint(uuid: uuid)
        }
        return constraint
    }
}
