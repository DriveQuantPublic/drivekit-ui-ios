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
import CoreLocation

public class BeaconViewModel {
    
    var vehicle : DKVehicle?
    let scanType : DKBeaconScanType
    var beacon : DKBeacon? = nil
    var delegate : ScanStateDelegate? = nil
    
    var vehiclePaired : DKVehicle?
    var beaconBattery : Int? = nil
    var clBeacon : CLBeacon? = nil
    var vehicles: [DKVehicle] = []
    
    public init(vehicle: DKVehicle, scanType: DKBeaconScanType) {
        self.vehicle = vehicle
        self.scanType = scanType
    }

    public init(scanType : DKBeaconScanType){
        self.scanType = scanType
        self.vehicle = nil
    }
    
    public init(scanType: DKBeaconScanType, beacon : DKBeacon, vehicles: [DKVehicle]) {
        self.vehicle = nil
        self.scanType = scanType
        self.beacon = beacon
        self.vehicles = vehicles
    }
    
    public init(scanType: DKBeaconScanType, beacon : DKBeacon) {
        self.vehicle = nil
        self.scanType = scanType
        self.beacon = beacon
    }
    
    public init(vehicle: DKVehicle, scanType: DKBeaconScanType, beacon : DKBeacon) {
        self.vehicle = vehicle
        self.scanType = scanType
        self.beacon = beacon
    }
    
    var vehicleName : String {
        return vehicle?.displayName ?? ""
    }
    
    func isBeaconValid() -> Bool {
        if let beacon = self.beacon, let clBeacon = self.clBeacon {
            return isBeaconValid(beacon: beacon, clBeacon: clBeacon)
        }else{
            return false
        }
    }
    
    private func isBeaconValid(beacon: DKBeacon, clBeacon: CLBeacon) -> Bool {
        return beacon.proximityUuid.uppercased() == clBeacon.proximityUUID.uuidString.uppercased() && beacon.major == Int(truncating: clBeacon.major) && beacon.minor == Int(truncating: clBeacon.minor)
    }
    
    func vehicleFromBeacon() -> DKVehicle? {
        var vehicle: DKVehicle? = nil
        for veh in vehicles {
            if let beacon = veh.beacon, let clBeacon = self.clBeacon, isBeaconValid(beacon: beacon, clBeacon: clBeacon) {
                vehicle = veh
            }
        }
        return vehicle
    }
    
    func checkCode(code: String, completion: @escaping (DKVehicleBeaconInfoStatus) -> ()) {
        DriveKitVehicle.shared.getBeacon(uniqueId: code, completionHandler: {status, beacon in
            self.beacon = beacon
            completion(status)
        })
    }
    
    func checkVehiclePaired(completion: @escaping (Bool) -> ()) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(completionHandler: {status, vehicles in
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
            completion(.error)
            return
        }
        if vehicle.beacon == nil {
            DriveKitVehicle.shared.addBeacon(vehicleId: vehicle.vehicleId, beacon: beacon, completionHandler: completion)
        }else{
            DriveKitVehicle.shared.removeBeacon(vehicleId: vehicle.vehicleId, completionHandler: { _ in
                DriveKitVehicle.shared.addBeacon(vehicleId: vehicle.vehicleId, beacon: beacon, completionHandler: completion)
            })
        }
    }
}


protocol ScanStateDelegate {
    func onStateUpdated(step: BeaconStep)
    func onScanFinished()
    func shouldShowLoader()
    func shouldHideLoader()
}

public enum DKBeaconScanType {
    case pairing, diagnostic, verify
}
