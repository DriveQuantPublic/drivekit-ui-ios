//
//  DKVehicle+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess

extension DKVehicle {
    var displayName : String {
        return name ?? String(format: "%@ %@", brand ?? "", model ?? "")
    }
}
