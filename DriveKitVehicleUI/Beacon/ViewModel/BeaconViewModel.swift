//
//  BeaconViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule
import CoreLocation

public class BeaconViewModel {
    var vehicle: DKVehicle?
    let scanType: DKBeaconScanType
    var beacon: DKBeacon? = nil
    weak var delegate: ScanStateDelegate? = nil

    var vehiclePaired: DKVehicle?
    private(set) var beaconBattery: Int? = nil
    private(set) var beaconDistance: Double? = nil
    var clBeacon: CLBeacon? = nil
    var vehicles: [DKVehicle] = []

    private let beaconScanner = DKBeaconScanner()

    var analyticsTagKey: String {
        get {
            let tagKey: String
            switch self.scanType {
                case .pairing:
                    tagKey = "dk_tag_vehicles_beacon_add"
                case .diagnostic:
                    tagKey = "dk_tag_vehicles_beacon_diagnosis"
                case .verify:
                    tagKey = "dk_tag_vehicles_beacon_verify"
            }
            return tagKey
        }
    }

    public init(vehicle: DKVehicle, scanType: DKBeaconScanType) {
        self.vehicle = vehicle
        self.scanType = scanType
    }

    public init(scanType: DKBeaconScanType) {
        self.scanType = scanType
        self.vehicle = nil
    }

    public init(scanType: DKBeaconScanType, beacon: DKBeacon, vehicles: [DKVehicle]) {
        self.vehicle = nil
        self.scanType = scanType
        self.beacon = beacon
        self.vehicles = vehicles
    }

    public init(scanType: DKBeaconScanType, beacon: DKBeacon) {
        self.vehicle = nil
        self.scanType = scanType
        self.beacon = beacon
    }

    public init(vehicle: DKVehicle, scanType: DKBeaconScanType, beacon: DKBeacon) {
        self.vehicle = vehicle
        self.scanType = scanType
        self.beacon = beacon
    }
    
    var vehicleName: String {
        return vehicle?.computeName() ?? ""
    }

    func startBeaconScan(completion: @escaping () -> ()) {
        if let beacon = self.beacon {
            self.beaconScanner.startBeaconScan(beacons: [beacon], useMajorMinor: self.scanType == .pairing) { beacon in
                if self.scanType != .pairing {
                    self.clBeacon = beacon
                }
                completion()
            }
        }
    }

    func stopBeaconScan() {
        self.beaconScanner.stopBeaconScan()
    }

    func startBeaconInfoScan() {
        self.beaconScanner.startBeaconInfoScan() { result in
            switch result {
                case let .success(batteryLevel, estimatedDistance):
                    self.update(battery: batteryLevel, distance: estimatedDistance)
                case .error:
                    self.update(battery: nil, distance: nil)
            }
            self.stopBeaconInfoScan()
        }
    }

    func stopBeaconInfoScan() {
        self.beaconScanner.stopBeaconInfoScan()
    }

    func update(battery: Int?, distance: Double?) {
        self.beaconBattery = battery
        self.beaconDistance = distance
        if let beaconBattery = self.beaconBattery, let clBeacon = self.clBeacon {
            let uuid: String
            if #available(iOS 13.0, *) {
                uuid = clBeacon.uuid.uuidString
            } else {
                uuid = clBeacon.proximityUUID.uuidString
            }
            let beacon = DKBeacon(uniqueId: nil, proximityUuid: uuid, major: clBeacon.major.intValue, minor: clBeacon.minor.intValue)
            DriveKitVehicle.shared.updateBeaconBatteryLevel(batteryLevel: beaconBattery, beacon: beacon) { _ in }
        }
    }
    
    func isBeaconValid() -> Bool {
        if let beacon = self.beacon, let clBeacon = self.clBeacon {
            return isBeaconValid(beacon: beacon, clBeacon: clBeacon)
        } else {
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
        } else {
            DriveKitVehicle.shared.removeBeacon(vehicleId: vehicle.vehicleId, completionHandler: { _ in
                DriveKitVehicle.shared.addBeacon(vehicleId: vehicle.vehicleId, beacon: beacon, completionHandler: completion)
            })
        }
    }
    
    func replaceBeacon(completion: @escaping (DKVehicleBeaconStatus) -> ()) {
        guard let pairedVehicle = self.vehiclePaired else {
            completion(.error)
            return
        }
        if vehiclePaired?.beacon == nil {
            addBeaconToVehicle(completion: completion)
        } else {
            DriveKitVehicle.shared.removeBeacon(vehicleId: pairedVehicle.vehicleId, completionHandler: { _ in
                self.addBeaconToVehicle(completion: completion)
            })
        }
    }
}


protocol ScanStateDelegate: AnyObject {
    func onStateUpdated(step: BeaconStep)
    func onScanFinished()
    func shouldShowLoader()
    func shouldHideLoader()
}

public enum DKBeaconScanType {
    case pairing, diagnostic, verify
}
