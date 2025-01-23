//
//  BeaconViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import CoreLocation
import DriveKitBeaconUtilsModule
import DriveKitCoreModule
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule
import Foundation

public class BeaconViewModel {
    var vehicle: DKVehicle?
    let scanType: DKBeaconScanType
    var beacon: DKBeacon?
    weak var delegate: ScanStateDelegate?

    var vehiclePaired: DKVehicle?
    private(set) var beaconBattery: Int?
    private(set) var beaconDistance: Double?
    private(set) var beaconRssi: Double?
    private(set) var beaconTxPower: Int?
    var clBeacon: CLBeacon?
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

    func startBeaconScan(completion: @escaping () -> Void) {
        if let beacon = self.beacon {
            DriveKitLog.shared.infoLog(
                tag: DriveKitVehicleUI.tag,
                message: "Beacon scanner launched in \(scanType) mode, vehicleId=\((vehicle?.vehicleId).logOrNil), major=\(beacon.major), minor=\(beacon.minor)"
            )
            self.beaconScanner.startBeaconScan(beacons: [beacon], useMajorMinor: self.scanType == .pairing) { beacons in
                if self.scanType != .pairing {
                    for foundBeacon in beacons {
                        if self.clBeacon == nil || (beacon.major == foundBeacon.major.intValue && beacon.minor == foundBeacon.minor.intValue) {
                            self.clBeacon = foundBeacon
                        }
                    }
                }
                if self.clBeacon != nil {
                    DriveKitLog.shared.infoLog(
                        tag: DriveKitVehicleUI.tag,
                        message: "Beacon scanner - Found: major=\(beacon.major), minor=\(beacon.minor)"
                    )
                }
                completion()
            }
        }
    }

    func stopBeaconScan() {
        self.beaconScanner.stopBeaconScan()
    }

    func startBeaconInfoScan() {
        self.beaconScanner.startBeaconInfoScan { result in
            switch result {
                case let .success(batteryLevel, estimatedDistance, rssi, txPower):
                    self.update(battery: batteryLevel, distance: estimatedDistance, rssi: rssi, txPower: txPower)
                case .error:
                    self.update(battery: nil, distance: nil, rssi: nil, txPower: nil)
                @unknown default:
                    self.update(battery: nil, distance: nil, rssi: nil, txPower: nil)
            }
        }
    }

    func stopBeaconInfoScan() {
        self.beaconScanner.stopBeaconInfoScan()
    }

    func update(battery: Int?, distance: Double?, rssi: Double?, txPower: Int?) {
        if let battery = battery, let distance = distance, let rssi = rssi {
            let update: Bool
            if let beaconRssi = self.beaconRssi {
                update = beaconRssi < rssi
            } else {
                update = true
            }
            if update {
                self.beaconBattery = battery
                self.beaconDistance = distance
                self.beaconRssi = rssi
                self.beaconTxPower = txPower
                if let beaconBattery = self.beaconBattery, let clBeacon = self.clBeacon {
                    let uuid: String = clBeacon.uuid.uuidString
                    let beacon = DKBeacon(uniqueId: nil, proximityUuid: uuid, major: clBeacon.major.intValue, minor: clBeacon.minor.intValue)
                    DriveKitVehicle.shared.updateBeaconBatteryLevel(batteryLevel: beaconBattery, beacon: beacon) { _ in }
                }
            }
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
        beacon.proximityUuid.uppercased() == clBeacon.uuid.uuidString.uppercased()
        && beacon.major == Int(truncating: clBeacon.major)
        && beacon.minor == Int(truncating: clBeacon.minor)
    }
    
    func vehicleFromBeacon() -> DKVehicle? {
        var vehicle: DKVehicle?
        for veh in vehicles {
            if let beacon = veh.beacon, let clBeacon = self.clBeacon, isBeaconValid(beacon: beacon, clBeacon: clBeacon) {
                vehicle = veh
            }
        }
        return vehicle
    }
    
    func checkCode(code: String, completion: @escaping (DKVehicleBeaconInfoStatus) -> Void) {
        DriveKitVehicle.shared.getBeacon(uniqueId: code, completionHandler: {status, beacon in
            self.beacon = beacon
            completion(status)
        })
    }
    
    func checkVehiclePaired(completion: @escaping (Bool) -> Void) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(completionHandler: {_, vehicles in
            for vehicle in vehicles {
                if let vehicleBeacon = vehicle.beacon, let beacon = self.beacon {
                    if vehicleBeacon.proximityUuid == beacon.proximityUuid && vehicleBeacon.major == beacon.major && vehicleBeacon.minor == beacon.minor {
                        self.vehiclePaired = vehicle
                    }
                }
            }
            
            let logAndComplete: (Bool) -> Void = { isSameVehicle in
                if isSameVehicle {
                    DriveKitLog.shared.infoLog(
                        tag: DriveKitVehicleUI.tag,
                        message: "Beacon scanner: beacon is already paired to this vehicle"
                    )
                }
                completion(isSameVehicle)
            }
            
            switch self.scanType {
            case .diagnostic:
                logAndComplete(self.vehiclePaired != nil)
            case .pairing,
                 .verify:
                if let vehicle = self.vehicle {
                    logAndComplete(vehicle.vehicleId == self.vehiclePaired?.vehicleId ?? "")
                }
            }
        })
    }
    
    func updateScanState(step: BeaconStep) {
        DriveKitLog.shared.infoLog(
            tag: DriveKitVehicleUI.tag,
            message: "Beacon scanner step update: \(step)"
        )
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
    
    func addBeaconToVehicle(toReplacePrevious isReplacingBeacon: Bool = false, oldVehicleId: String? = nil, completion: @escaping (DKVehicleBeaconStatus) -> Void) {
        let logThenComplete: (DKVehicleBeaconStatus) -> Void = {
            if isReplacingBeacon == false {
                DriveKitLog.shared.infoLog(
                    tag: DriveKitVehicleUI.tag,
                    message: "Beacon scanner - Add beacon status: \($0.name)"
                )
            }
            completion($0)
        }
        guard let beacon = self.beacon, let vehicle = self.vehicle else {
            logThenComplete(.error)
            return
        }
        if vehicle.beacon == nil && oldVehicleId == nil {
            DriveKitVehicle.shared.addBeacon(vehicleId: vehicle.vehicleId, beacon: beacon, completionHandler: logThenComplete)
        } else {
            DriveKitVehicle.shared.changeBeacon(
                vehicleId: vehicle.vehicleId,
                oldVehicleId: oldVehicleId ?? vehicle.vehicleId,
                beacon: beacon,
                completionHandler: logThenComplete
            )
        }
    }
    
    func replaceBeacon(completion: @escaping (DKVehicleBeaconStatus) -> Void) {
        let logThenComplete: (DKVehicleBeaconStatus) -> Void = {
            DriveKitLog.shared.infoLog(
                tag: DriveKitVehicleUI.tag,
                message: "Beacon scanner - Change beacon status: \($0.name)"
            )
            completion($0)
        }
        guard let pairedVehicle = self.vehiclePaired else {
            logThenComplete(.error)
            return
        }
        if vehiclePaired?.beacon == nil {
            addBeaconToVehicle(toReplacePrevious: true, completion: logThenComplete)
        } else {
            self.addBeaconToVehicle(toReplacePrevious: true, oldVehicleId: pairedVehicle.vehicleId, completion: logThenComplete)
        }
    }
}

protocol ScanStateDelegate: AnyObject {
    func onStateUpdated(step: BeaconStep)
    func onScanFinished()
    func shouldShowLoader()
    func shouldHideLoader()
}

public enum DKBeaconScanType: String {
    case pairing, diagnostic, verify
}

extension DKVehicleBeaconStatus {
    var name: String {
        switch self {
        case .success:
            return "Success"
        case .error:
            return "Error"
        case .unknownVehicle:
            return "Unknown vehicle"
        case .unavailableBeacon:
            return "Unavailable beacon"
        @unknown default:
            return "Error"
        }
    }
}
