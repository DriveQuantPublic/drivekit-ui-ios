//
//  BeaconViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitVehicle

class BeaconViewModel {
    private let vehicle : DKVehicle
    
    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
    }
    
    func checkCode(code: String, completion: @escaping (DKVehicleBeaconStatus, DKVehicleGetBeaconResponse?) -> ()) {
        DriveKitVehicleManager.shared.getBeacon(uniqueId: code, completionHandler: completion)
    }
}
