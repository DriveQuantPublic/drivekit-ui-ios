//
//  BeaconHelper.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 03/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth
import DriveKitDBVehicleAccessModule

@objc public class BeaconHelper: NSObject {
    public typealias BeaconFound = (_ beacon: CLBeacon) -> Void
    public typealias BatteryLevelResult = (_ result: BeaconResult) -> Void
    public typealias BatteryLevelCompletion = (_ beaconIdentifier: String?, _ batteryLevel: Int, _ error: Bool) -> Void
    private let beaconTypes: [DKBeaconType]?
    private var beacons: [DKBeacon]? = nil
    private var locationManager: CLLocationManager? = nil
    private var centralManager: CBCentralManager? = nil
    private var scanningBattery = false
    private var onBeaconFoundBlock: BeaconFound? = nil
    private var completionBlock: BatteryLevelResult? = nil
    private var objcCompletionBlock: BatteryLevelCompletion? = nil

    override init() {
        self.beaconTypes = [.feasycom, .kontakt, .kontaktPro]
    }

    init(beaconTypes: [DKBeaconType] = [.feasycom, .kontakt, .kontaktPro]) {
        self.beaconTypes = beaconTypes.isEmpty ? [.feasycom, .kontakt, .kontaktPro] : beaconTypes
    }

    @objc public func startBeaconScan(beacons: [DKBeacon], onBeaconFound: @escaping BeaconFound) {
        if self.beacons == nil {
            self.beacons = beacons
            self.onBeaconFoundBlock = onBeaconFound
            if self.locationManager == nil {
                self.createLocationManager()
            }
            if let locationManager = self.locationManager {
                for beacon in beacons {
                    if #available(iOS 13.0, *) {
                        locationManager.startRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: false))
                    } else {
                        locationManager.startRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: false))
                    }
                }
            }
        }
    }

    private func createLocationManager() {
        if Thread.isMainThread {
            self.unsafeCreateLocationManager()
        } else {
            DispatchQueue.main.sync {
                self.unsafeCreateLocationManager()
            }
        }
    }
    private func unsafeCreateLocationManager() {
        if self.locationManager == nil {
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            self.locationManager = locationManager
        }
    }

    @objc public func stopBeaconScan() {
        if let beacons = self.beacons, let locationManager = self.locationManager {
            for beacon in beacons {
                if #available(iOS 13.0, *) {
                    locationManager.stopRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: false))
                } else {
                    locationManager.stopRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: false))
                }
            }
        }
        self.onBeaconFoundBlock = nil
    }

    public func startBatteryLevelRetrieval(completion: @escaping BatteryLevelResult) {
        self.completionBlock = completion
        internalStartBatteryLevelRetrieval()
    }

    @objc(startBatteryLevelRetrieval:) public func objc_startBatteryLevelRetrieval(completion: @escaping BatteryLevelCompletion) {
        self.objcCompletionBlock = completion
        internalStartBatteryLevelRetrieval()
    }

    private func internalStartBatteryLevelRetrieval() {
        if self.centralManager != nil {
            startBatteryScan()
        } else {
            self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        }
    }

    @objc public func stopBatteryLevelRetrieval() {
        if let centralManager = self.centralManager, centralManager.state == .poweredOn {
            centralManager.stopScan()
        }
        self.completionBlock = nil
        self.objcCompletionBlock = nil
        self.scanningBattery = false
    }

    private func startBatteryScan() {
        if let centralManager = self.centralManager, let types = self.beaconTypes {
            if !self.scanningBattery && centralManager.state == .poweredOn {
                self.scanningBattery = true
                let services: [CBUUID] = types.map { CBUUID(string: $0.service) }
                centralManager.scanForPeripherals(withServices: services, options: nil)
            }
        }
    }
}


extension BeaconHelper : CLLocationManagerDelegate {
    @available(iOS 13.0, *)
    public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        onBeaconsFound(beacons)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        onBeaconsFound(beacons)
    }

    private func onBeaconsFound(_ beacons: [CLBeacon]) {
        if let onBeaconFoundBlock = self.onBeaconFoundBlock {
            for beacon in beacons {
                onBeaconFoundBlock(beacon)
            }
        } else {
            stopBeaconScan()
        }
    }
}


extension BeaconHelper: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ centralManager: CBCentralManager) {
        switch centralManager.state {
            case .poweredOn:
                startBatteryScan()
            case .poweredOff, .unauthorized, .unsupported:
                if let completionBlock = self.completionBlock {
                    completionBlock(.error)
                }
                if let objcCompletionBlock = self.objcCompletionBlock {
                    objcCompletionBlock(nil, 0, true)
                }
            default:
                break
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? Dictionary<CBUUID, Data>, let beaconTypes = self.beaconTypes else {
            return
        }
        var beaconIdentifier: String? = nil
        var batteryPower: Int? = nil
        for beaconType in beaconTypes {
            let (power, id) = beaconType.parse(serviceData: serviceData)
            if let power = power {
                batteryPower = power
                beaconIdentifier = id
                break
            }
        }
        if let batteryPower = batteryPower {
            var stop = true
            if let completionBlock = self.completionBlock {
                completionBlock(.success(identifier: beaconIdentifier, batteryLevel: batteryPower))
                stop = false
            }
            if let objcCompletionBlock = self.objcCompletionBlock {
                objcCompletionBlock(beaconIdentifier, batteryPower, false)
                stop = false
            }
            if stop {
                stopBatteryLevelRetrieval()
            }
        }
    }
}

public enum BeaconResult {
    case success(identifier: String?, batteryLevel: Int)
    case error
}

@objc public enum DKBeaconType: Int {
    case kontakt
    case kontaktPro
    case feasycom

    var service: String {
        switch self {
            case .kontakt:
                return "D00D"
            case .kontaktPro:
                return "FE6A"
            case .feasycom:
                return "FFF0"
        }
    }

    func parse(serviceData: Dictionary<CBUUID, Data>) -> (batteryPower: Int?, beaconIdentifier: String?) {
        if let data = serviceData[CBUUID(string: self.service)] {
            let batteryPower: Int?
            let beaconIdentifier: String?
            switch self {
                case .kontakt:
                    // Kontakt.io Beacon data from old advertismentData.
                    // Parse identifier get byte 0 - 3.
                    guard let beaconId = String(data: data.subdata(in: Range(0...3)), encoding: String.Encoding.ascii) else {
                        return (nil, nil)
                    }
                    beaconIdentifier = beaconId
                    // Parse battery level get byte 6.
                    var power: UInt8 = 0
                    data.copyBytes(to: &power, from: 6..<7)
                    batteryPower = Int(power)
                case .kontaktPro:
                    // Kontakt.io Beacon data from new (pro beacons) advertismentData.
                    // Parse identifier get byte 6 - 9.
                    guard let beaconId = String(data: data.subdata(in: Range(6...9)), encoding: String.Encoding.ascii) else {
                        return (nil, nil)
                    }
                    beaconIdentifier = beaconId
                    // Parse battery level get byte 4.
                    var power: UInt8 = 0
                    data.copyBytes(to: &power, from: 4..<5)
                    batteryPower = Int(power)
                case .feasycom:
                    // Feasycom beacon data.
                    var power: UInt8 = 0
                    data.copyBytes(to: &power, from: 10..<11)
                    batteryPower = Int(power)
                    beaconIdentifier = nil
            }
            return (batteryPower, beaconIdentifier)
        } else {
            return (nil, nil)
        }
    }
}
