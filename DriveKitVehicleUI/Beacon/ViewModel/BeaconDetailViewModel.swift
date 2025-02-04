// swiftlint:disable no_magic_numbers
//
//  BeaconDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 17/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccessModule
import CoreLocation

class BeaconDetailViewModel {
    var data: [[String: NSMutableAttributedString]]
    
    init(vehicle: DKVehicle?, beacon: CLBeacon, batteryLevel: String, distance: Double?, rssi: Double?, txPower: Int?) {
        self.data = []
        if let vehicleName = vehicle?.computeName().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build() {
            data.append(["dk_beacon_vehicule_linked": vehicleName])
        } else {
            data.append([
                "dk_beacon_vehicule_linked": "dk_beacon_vehicle_unknown"
                    .dkVehicleLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .normalText)
                    .color(.complementaryFontColor)
                    .build()
            ])
        }
        let idx = beacon.uuid.uuidString.index(beacon.uuid.uuidString.startIndex, offsetBy: 7)
        let uuid = String(beacon.uuid.uuidString.lowercased()[...idx]) + "..."
        let rssiValue: Int
        if let rssi = rssi {
            rssiValue = Int(rssi)
        } else {
            rssiValue = beacon.rssi
        }
        let txPowerString: String
        if let txPower = txPower {
            txPowerString = "\(txPower) dBm"
        } else {
            txPowerString = "-"
        }
        data.append(["dk_beacon_uuid": uuid.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()])
        data.append(["dk_vehicle_beacon_major": "\(beacon.major)".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()])
        data.append(["dk_vehicle_beacon_minor": "\(beacon.minor)".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()])
        data.append(["dk_beacon_battery": batteryLevel.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()])
        data.append([
            "dk_beacon_distance": "\((distance ?? beacon.accuracy).formatMeterDistance())"
                .dkAttributedString()
                .font(dkFont: .primary, style: .highlightSmall)
                .color(.primaryColor)
                .build()
        ])
        data.append(["dk_beacon_rssi": "\(rssiValue) dBm".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()])
        data.append(["dk_beacon_tx": txPowerString.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()])
    }
    
    func mailContent() -> String {
        var content = ""
        data.forEach {
            if let key = $0.keys.first {
                content += "\(key.dkVehicleLocalized()) : \($0[key]?.string ?? "")\n"
            }
        }
        return content
    }
}
