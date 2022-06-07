//
//  DKBeaconConfig.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 06/06/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

@objc public protocol DKBeaconConfig {
    var serviceUuid: String { get }
    var batteryLevelPositionInService: Int { get }
    var rssiAtOneMeter: Int { get }
}


//MARK: - Kontakt implementations.

@objc public class DKKontaktBeacon: NSObject, DKBeaconConfig {
    public var serviceUuid: String = "D00D"
    public var batteryLevelPositionInService: Int = 6
    public var rssiAtOneMeter: Int = -81
}

@objc public class DKKontaktProBeacon: NSObject, DKBeaconConfig {
    public var serviceUuid: String = "FE6A"
    public var batteryLevelPositionInService: Int = 4
    public var rssiAtOneMeter: Int = -81
}


//MARK: - Feasycom implementation.

@objc public class DKFeasycomBeacon: NSObject, DKBeaconConfig {
    private let rssiAt1m: Int

    public init(rssiAt1m: Int = -65) {
        self.rssiAt1m = rssiAt1m
    }

    public var serviceUuid: String = "FFF0"
    public var batteryLevelPositionInService: Int = 10
    public var rssiAtOneMeter: Int {
        return self.rssiAt1m
    }
}
