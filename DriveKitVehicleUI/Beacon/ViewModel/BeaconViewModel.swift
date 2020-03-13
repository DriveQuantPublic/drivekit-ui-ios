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

public class BeaconViewModel {
    
    private let vehicle : DKVehicle?
    let scanType : BeaconScanType
    var beacon : DKVehicleGetBeaconResponse? = nil
    var delegate : ScanStateDelegate? = nil
    
    var vehiclePaired : DKVehicle?
    
    public init(vehicle: DKVehicle, scanType: BeaconScanType) {
        self.vehicle = vehicle
        self.scanType = scanType
    }
    
    public init(scanType: BeaconScanType, beacon : DKVehicleGetBeaconResponse) {
        self.vehicle = nil
        self.scanType = scanType
        self.beacon = beacon
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
            switch self.scanType {
            case .pairing:
                if let vehicle = self.vehicle {
                    completion(vehicle.vehicleId == self.vehiclePaired?.vehicleId ?? "")
                }
            case .diagnostic:
                completion(self.vehiclePaired != nil)
            case .verify:
                if let vehicle = self.vehicle {
                    completion(vehicle.vehicleId == self.vehiclePaired?.vehicleId ?? "")
                }
            }
            
                
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
        guard let beacon = self.beacon, let vehicle = self.vehicle else {
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

public enum BeaconScanType {
    case pairing, diagnostic, verify
}
