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

enum TripListConfiguration {
    case motorized(vehicleId: String? = nil)
    case alternative(transportationMode: TransportationMode? = nil)
    
    func transportationModes() -> [TransportationMode] {
        switch self {
            case .motorized:
                return TransportationMode.allCases.filter { !$0.isAlternative() }
            case .alternative:
                return TransportationMode.allCases.filter { $0.isAlternative() }
        }
    }
    
    func identifier() -> String {
        switch self {
            case .motorized:
                return "dkMotorized"
            case .alternative:
                return "dkAlternative"
        }
    }
}

extension TripListConfiguration: DKFilterItem {
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
