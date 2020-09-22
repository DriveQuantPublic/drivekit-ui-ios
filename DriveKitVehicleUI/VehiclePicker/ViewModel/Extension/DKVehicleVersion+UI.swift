//
//  DKVehicleVersion+UI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 09/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitVehicleModule

extension DKVehicleVersion : VehiclePickerTableViewItem {
    func text() -> String {
        return self.version
    }
}
