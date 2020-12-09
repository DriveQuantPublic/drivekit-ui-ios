//
//  TransportationMode+DKFilter.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 09/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension TransportationMode : DKFilterItem {
    public func getImage() -> UIImage? {
        var image = ""
        switch self {
            case .unknown, .other:
                image = "dk_transportation_other"
            case .car:
                image = "dk_transportation_car"
            case .moto:
                image = "dk_transportation_motorcycle"
            case .truck:
                image = "dk_transportation_truck"
            case .bus:
                image = "dk_transportation_bus"
            case .train:
                image = "dk_transportation_train"
            case .boat:
                image = "dk_transportation_boat"
            case .bike:
                image = "dk_transportation_bicycle"
            case .flight:
                image = "dk_transportation_plane"
            case .skiing:
                image = "dk_transportation_skiing"
            case .onFoot:
                image = "dk_transportation_on_foot"
            case .idle:
                image = "dk_transportation_idle"
        }
        return UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)
    }
    
    public func getName() -> String {
        var localizable = ""
        switch self {
            case .unknown, .other:
                localizable = "dk_transportation_mode_other"
            case .car:
                localizable = "dk_transportation_mode_car"
            case .moto:
                localizable = "dk_transportation_mode_motorcycle"
            case .truck:
                localizable = "dk_transportation_mode_truck"
            case .bus:
                localizable = "dk_transportation_mode_bus"
            case .train:
                localizable = "dk_transportation_mode_train"
            case .boat:
                localizable = "dk_transportation_mode_boat"
            case .bike:
                localizable = "dk_transportation_mode_bike"
            case .flight:
                localizable = "dk_transportation_mode_flight"
            case .skiing:
                localizable = "dk_transportation_mode_skiing"
            case .onFoot:
                localizable = "dk_transportation_mode_on_foot"
            case .idle:
                localizable = "dk_transportation_mode_idle"
        }
        return localizable.dkDriverDataLocalized()
    }
    
    public func getId() -> Any? {
        return self
    }
}
