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
    var beacon : DKVehicleGetBeaconResponse? = nil
    var delegate : ScanStateDelegate? = nil
    var isDiag : Bool = false
    
    var vehiclePaired : DKVehicle?
    
    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
    }
    
    func checkCode(code: String, completion: @escaping (DKVehicleBeaconStatus) -> ()) {
        DriveKitVehicleManager.shared.getBeacon(uniqueId: code, completionHandler: {status, beacon in
            self.beacon = beacon
            completion(status)
        })
    }
    
    func checkVehiclePaired(completion: @escaping (Bool) -> ()) {
        DriveKitVehicleManager.shared.getVehiclesOrderByNameAsc(completionHandler: {status, vehicles in
            for vehicle in vehicles {
                if let vehicleBeacon = vehicle.beacon, let beacon = self.beacon  {
                    if vehicleBeacon.proximityUuid == beacon.proximityUuid && vehicleBeacon.major == beacon.major && vehicleBeacon.minor == beacon.minor {
                        self.vehiclePaired = vehicle
                    }
                }
            }
            completion(self.vehicle.vehicleId == self.vehiclePaired?.vehicleId ?? "")
        })
    }
    
    func updateScanState(step: BeaconStep) {
        if let delegate = self.delegate {
            delegate.onStateUpdated(step: step)
        }
    }
    
    func scanValidationFinished() {
        if let delegate = self.delegate {
            delegate.onScanFinished()
        }
    }
    
    func showLoader() {
        if let delegate = self.delegate {
            delegate.shouldShowLoader()
        }
    }
    
    func hideLoader() {
        if let delegate = self.delegate {
            delegate.shouldHideLoader()
        }
    }
    
    func addBeaconToVehicle(completion: @escaping (DKVehicleBeaconStatus) -> ()) {
        guard let beacon = self.beacon else {
            completion(.invalidBeacon)
            return
        }
        DriveKitVehicleManager.shared.addBeacon(vehicleId: vehicle.vehicleId ?? "", minor: beacon.minor, major: beacon.major, proximityUuid: beacon.proximityUuid, uniqueId: beacon.uniqueId, completionHandler: completion)
    }
}


protocol ScanStateDelegate {
    func onStateUpdated(step: BeaconStep)
    func onScanFinished()
    func shouldShowLoader()
    func shouldHideLoader()
}
