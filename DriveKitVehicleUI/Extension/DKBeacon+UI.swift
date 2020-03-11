//
//  DKBeacon+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicle
import CoreLocation

extension DKVehicleGetBeaconResponse {
    func toCLBeaconRegion() -> CLBeaconRegion {
        var region = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityUuid)!, identifier: "DKscannedBeacon")
        if major >= 0{
            region = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityUuid)!, major : CLBeaconMajorValue(major), identifier: "DKscannedBeacon")
            if minor >= 0 {
                region = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityUuid)!, major : CLBeaconMajorValue(major), minor : CLBeaconMinorValue(minor), identifier: "DKscannedBeacon")
            }
        }
        return region
    }
    
    @available(iOS 13.0, *)
    func toCLBeaconIdentityConstraint() -> CLBeaconIdentityConstraint {
        var constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: proximityUuid)!)
        if major >= 0{
            constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: proximityUuid)!, major : CLBeaconMajorValue(major))
            if minor >= 0 {
                constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: proximityUuid)!, major : CLBeaconMajorValue(major), minor : CLBeaconMinorValue(minor))
            }
        }
        return constraint
    }
}
