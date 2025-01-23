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
    func toCLBeaconRegion(noMajorMinor: Bool) -> CLBeaconRegion {
        let identifier = "DKscannedBeacon"
        let proximityUuid = UUID(uuidString: self.proximityUuid)!
        let region: CLBeaconRegion
        if !noMajorMinor && self.major >= 0 {
            if self.minor >= 0 {
                region = CLBeaconRegion(uuid: proximityUuid, major: CLBeaconMajorValue(self.major), minor: CLBeaconMinorValue(self.minor), identifier: identifier)
            } else {
                region = CLBeaconRegion(uuid: proximityUuid, major: CLBeaconMajorValue(self.major), identifier: identifier)
            }
        } else {
            region = CLBeaconRegion(uuid: proximityUuid, identifier: identifier)
        }
        return region
    }
    
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
