//
//  TripListConfiguration.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 08/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

enum TriplistConfiguration {
    case motorized(String?), alternative(TransportationMode?)
    
    func transportationModes() -> [TransportationMode] {
        switch self {
            case .motorized:
                return [.unknown, .car, .moto, .truck]
            case .alternative:
                return [.bike, .boat, .bus, .flight, .idle, .onFoot, .other, .skiing, .train]
        }
    }
    
    func identifier() -> String {
        switch self {
            case .motorized(_):
                return "dkMotorized"
            case .alternative(_):
                return "dkAlternative"
        }
    }
}

extension TriplistConfiguration: DKFilterItem {
    func getImage() -> UIImage? {
        return nil
    }
    
    func getName() -> String {
        switch self {
            case .motorized(_):
                return "dk_driverdata_vehicle_trips".dkDriverDataLocalized()
            case .alternative(_):
                return "dk_driverdata_alternative_trips".dkDriverDataLocalized()
        }
    }
    
    func getId() -> Any? {
        return self
    }
}
