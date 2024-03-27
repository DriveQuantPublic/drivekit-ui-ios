// swiftlint:disable cyclomatic_complexity
//
//  TransportationMode+DKFilter.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 09/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension TransportationMode: DKFilterItem {
    public func getImage() -> UIImage? {
        switch self {
            case .unknown, .other:
                return DKDriverDataImages.transportationOther.image
            case .car:
                return DKDriverDataImages.transportationCar.image
            case .moto:
                return DKDriverDataImages.transportationMotorcycle.image
            case .truck:
                return DKDriverDataImages.transportationTruck.image
            case .bus:
                return DKDriverDataImages.transportationBus.image
            case .train:
                return DKDriverDataImages.transportationTrain.image
            case .boat:
                return DKDriverDataImages.transportationBoat.image
            case .bike:
                return DKDriverDataImages.transportationBicyle.image
            case .flight:
                return DKDriverDataImages.transportationPlane.image
            case .skiing:
                return DKDriverDataImages.transportationSkiing.image
            case .onFoot:
                return DKDriverDataImages.transportationOnFoot.image
            case .idle:
                return DKDriverDataImages.transportationIdle.image
            @unknown default:
                return nil
        }
    }
    
    public func getName() -> String {
        var localizable = ""
        switch self {
            case .unknown, .other:
                localizable = "dk_driverdata_transportation_mode_other"
            case .car:
                localizable = "dk_driverdata_transportation_mode_car"
            case .moto:
                localizable = "dk_driverdata_transportation_mode_motorcycle"
            case .truck:
                localizable = "dk_driverdata_transportation_mode_truck"
            case .bus:
                localizable = "dk_driverdata_transportation_mode_bus"
            case .train:
                localizable = "dk_driverdata_transportation_mode_train"
            case .boat:
                localizable = "dk_driverdata_transportation_mode_boat"
            case .bike:
                localizable = "dk_driverdata_transportation_mode_bike"
            case .flight:
                localizable = "dk_driverdata_transportation_mode_flight"
            case .skiing:
                localizable = "dk_driverdata_transportation_mode_skiing"
            case .onFoot:
                localizable = "dk_driverdata_transportation_mode_on_foot"
            case .idle:
                localizable = "dk_driverdata_transportation_mode_idle"
            @unknown default:
                return ""
        }
        return localizable.dkDriverDataLocalized()
    }
    
    public func getId() -> Any? {
        return self
    }
}
