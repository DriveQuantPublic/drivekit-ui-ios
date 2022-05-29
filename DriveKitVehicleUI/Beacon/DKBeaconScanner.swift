//
//  DKBeaconScanner.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 03/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth
import DriveKitCoreModule
import DriveKitDBVehicleAccessModule
import DriveKitVehicleModule

@objc public class DKBeaconScanner: NSObject {
    private let tag: String = "DriveKit BeaconScanner"
    @objc public static var beaconConfigList: [DKBeaconConfig] = [DKKontaktBeacon(), DKFeasycomBeacon()]
    public typealias BeaconFound = (_ beacon: CLBeacon) -> ()
    public typealias BeaconInfoScanResult = (_ result: BeaconInfoResult) -> ()
    public typealias ObjcBeaconInfoScanResult = (_ batteryLevel: Int, _ estimatedDistance: Double, _ error: Bool) -> Void
    private var beaconsToScan: [DKBeacon]? = nil
    private var useMajorMinor: Bool = false
    private var beaconInfoConfigurations: [DKBeaconConfig]? = nil
    private var locationManager: CLLocationManager? = nil
    private var centralManager: CBCentralManager? = nil
    private var beaconFoundBlock: BeaconFound? = nil
    private var beaconInfoResultCompletionBlock: BeaconInfoScanResult? = nil
    private var objcBeaconInfoResultCompletionBlock: ObjcBeaconInfoScanResult? = nil

    // MARK: - iBeacon scan.

    @objc public func startBeaconScan(beacons: [DKBeacon], useMajorMinor: Bool, completion: @escaping BeaconFound) {
        if self.beaconsToScan == nil {
            self.beaconsToScan = beacons
            self.useMajorMinor = useMajorMinor
            self.beaconFoundBlock = completion
            if self.locationManager == nil {
                self.createLocationManager()
            }
            if let locationManager = self.locationManager {
                for beacon in beacons {
                    if #available(iOS 13.0, *) {
                        locationManager.startRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: !useMajorMinor))
                    } else {
                        locationManager.startRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: !useMajorMinor))
                    }
                }
            }
        } else {
            DriveKitLog.shared.infoLog(tag: self.tag, message: "A beacon scan is already in progress.")
        }
    }

    @objc public func stopBeaconScan() {
        if let beacons = self.beaconsToScan, let locationManager = self.locationManager {
            for beacon in beacons {
                if #available(iOS 13.0, *) {
                    locationManager.stopRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: false))
                } else {
                    locationManager.stopRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: false))
                }
            }
        }
        self.beaconsToScan = nil
        self.beaconFoundBlock = nil
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

    private func internalStartBeaconInfoRetrieval() {
        if self.centralManager != nil {
            startBeaconInfoScan()
        } else {
            self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        }
    }


    // MARK: - Beacon info scan.

    public func startBeaconInfoScan(configurations: [DKBeaconConfig] = DKBeaconScanner.beaconConfigList, completion: @escaping BeaconInfoScanResult) {
        if self.beaconInfoConfigurations == nil {
            self.beaconInfoConfigurations = configurations
            self.beaconInfoResultCompletionBlock = completion
            internalStartBeaconInfoRetrieval()
        } else {
            DriveKitLog.shared.infoLog(tag: self.tag, message: "A beacon info retrieval is already in progress.")
        }
    }

    @objc(startBeaconInfoScan:) public func objc_startBeaconInfoScan(completion: @escaping ObjcBeaconInfoScanResult) {
        objc_startBeaconInfoRetrieval(configurations: DKBeaconScanner.beaconConfigList, completion: completion)
    }

    @objc(startBeaconInfoRetrievalWithConfigurations:completion:) public func objc_startBeaconInfoRetrieval(configurations: [DKBeaconConfig], completion: @escaping ObjcBeaconInfoScanResult) {
        if self.beaconInfoConfigurations == nil {
            self.beaconInfoConfigurations = configurations
            self.objcBeaconInfoResultCompletionBlock = completion
            internalStartBeaconInfoRetrieval()
        } else {
            DriveKitLog.shared.infoLog(tag: self.tag, message: "A beacon info retrieval is already in progress.")
        }
    }

    @objc public func stopBeaconInfoScan() {
        if let centralManager = self.centralManager, centralManager.state == .poweredOn {
            centralManager.stopScan()
        }
        self.beaconInfoConfigurations = nil
        self.beaconInfoResultCompletionBlock = nil
        self.objcBeaconInfoResultCompletionBlock = nil
    }

    private func startBeaconInfoScan() {
        if let centralManager = self.centralManager, let beaconInfoConfigurations = self.beaconInfoConfigurations {
            if centralManager.state == .poweredOn {
                let services: [CBUUID] = beaconInfoConfigurations.map { CBUUID(string: $0.serviceUuid) }
                centralManager.scanForPeripherals(withServices: services, options: nil)
            }
        }
    }
}

// MARK: -

extension DKBeaconScanner: CLLocationManagerDelegate {
    @available(iOS 13.0, *)
    public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        onBeaconsFound(beacons)
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        onBeaconsFound(beacons)
    }

    private func onBeaconsFound(_ beacons: [CLBeacon]) {
        if let onBeaconFoundBlock = self.beaconFoundBlock {
            for beacon in beacons {
                onBeaconFoundBlock(beacon)
            }
        } else {
            stopBeaconScan()
        }
    }
}


extension DKBeaconScanner: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ centralManager: CBCentralManager) {
        switch centralManager.state {
            case .poweredOn:
                startBeaconInfoScan()
            case .poweredOff, .unauthorized, .unsupported:
                if let completionBlock = self.beaconInfoResultCompletionBlock {
                    completionBlock(.error)
                }
                if let objcCompletionBlock = self.objcBeaconInfoResultCompletionBlock {
                    objcCompletionBlock(0, 0.0, true)
                }
            default:
                break
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let beaconInfoConfigurations = self.beaconInfoConfigurations, let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? Dictionary<CBUUID, Data> else {
            return
        }
        var batteryPower: Int? = nil
        var rssiAt1m: Int? = nil
        for beaconConfig in beaconInfoConfigurations {
            if let power = parse(serviceData: serviceData, config: beaconConfig) {
                batteryPower = power
                rssiAt1m = beaconConfig.rssiAtOneMeter
                break
            }
        }
        if let batteryPower = batteryPower, let rssiAt1m = rssiAt1m {
            let estimatedDistance = distance(fromRssi: RSSI, rssiAt1m: rssiAt1m)
            var stop = true
            if let completionBlock = self.beaconInfoResultCompletionBlock {
                completionBlock(.success(batteryLevel: batteryPower, estimatedDistance: estimatedDistance))
                stop = false
            }
            if let objcCompletionBlock = self.objcBeaconInfoResultCompletionBlock {
                objcCompletionBlock(batteryPower, estimatedDistance, false)
                stop = false
            }
            if stop {
                stopBeaconInfoScan()
            }
        }
    }

    private func parse(serviceData: Dictionary<CBUUID, Data>, config: DKBeaconConfig) -> Int? {
        let batteryPower: Int?
        if let data = serviceData[CBUUID(string: config.serviceUuid)] {
            let batteryLevelPosition = config.batteryLevelPositionInService
            var power: UInt8 = 0
            data.copyBytes(to: &power, from: batteryLevelPosition..<(batteryLevelPosition + 1))
            batteryPower = Int(power)
        } else {
            batteryPower = nil
        }
        return batteryPower
    }

    private func distance(fromRssi rssi: NSNumber, rssiAt1m: Int) -> Double {
        return Double(truncating: pow(10.0, (Double(rssiAt1m) - rssi.doubleValue) / (2.0 * 10)) as NSNumber)
    }
}

public enum BeaconInfoResult {
    case success(batteryLevel: Int, estimatedDistance: Double)
    case error
}
