//
//  KontaktBeaconHelper.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 03/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth
import DriveKitDBVehicleAccessModule

@objc public class KontaktBeaconHelper : NSObject {
    public typealias BeaconFound = (_ beacon: CLBeacon) -> Void
    public typealias BatteryLevelResult = (_ result: BeaconResult) -> Void
    public typealias BatteryLevelCompletion = (_ beaconIdentifier: String?, _ batteryLevel: Int, _ error: Bool) -> Void
    private var beacons: [DKBeacon]? = nil
    private var locationManager: CLLocationManager? = nil
    private var centralManager: CBCentralManager? = nil
    private var scanningBattery = false
    private var onBeaconFoundBlock: BeaconFound? = nil
    private var completionBlock: BatteryLevelResult? = nil
    private var objcCompletionBlock: BatteryLevelCompletion? = nil

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
                        locationManager.startRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: true))
                    } else {
                        locationManager.startRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: true))
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
                    locationManager.stopRangingBeacons(satisfying: beacon.toCLBeaconIdentityConstraint(noMajorMinor: true))
                } else {
                    locationManager.stopRangingBeacons(in: beacon.toCLBeaconRegion(noMajorMinor: true))
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
        if let centralManager = self.centralManager {
            if !self.scanningBattery && centralManager.state == .poweredOn {
                self.scanningBattery = true
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        }
    }
}


extension KontaktBeaconHelper : CLLocationManagerDelegate {
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


extension KontaktBeaconHelper : CBCentralManagerDelegate {
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
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? Dictionary<CBUUID, Data> else {
            return
        }

        let beaconIdentifier: String?
        let batteryPower: Int?
        if let ktkOldData = serviceData[CBUUID(string:"D00D")] {
            // Kontakt.io Beacon data from old advertismentData.
            // Parse identifier get byte 0 - 3.
            guard let beaconId = String(data: ktkOldData.subdata(in: Range(0...3)), encoding: String.Encoding.ascii) else {
                return
            }
            beaconIdentifier = beaconId
            // Parse battery level get byte 6.
            var power: UInt8 = 0
            ktkOldData.copyBytes(to: &power, from: 6..<7)
            batteryPower = Int(power)
        } else if let ktkNewData = serviceData[CBUUID(string:"FE6A")] {
            // Kontakt.io Beacon data from new (pro beacons) advertismentData.
            // Parse identifier get byte 6 - 9.
            guard let beaconId = String(data: ktkNewData.subdata(in: Range(6...9)), encoding: String.Encoding.ascii) else {
                return
            }
            beaconIdentifier = beaconId
            // Parse battery level get byte 4.
            var power: UInt8 = 0
            ktkNewData.copyBytes(to: &power, from: 4..<5)
            batteryPower = Int(power)
        } else {
            beaconIdentifier = nil
            batteryPower = nil
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
