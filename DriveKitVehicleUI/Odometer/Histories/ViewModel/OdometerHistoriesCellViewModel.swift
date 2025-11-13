//
//  OdometerHistoriesCellViewModel.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 26/10/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

struct OdometerHistoriesCellViewModel {
    private let history: DKVehicleOdometerHistory

    init(history: DKVehicleOdometerHistory) {
        self.history = history
    }

    func getDistance() -> String {
        return self.history.distance.formatKilometerDistance(minDistanceToRemoveFractions: 0, forcedUnitSystem: .metric)
    }

    func getDate() -> String {
        let date = history.updateDate ?? Date()
        return date.format(pattern: .fullDate).capitalizeFirstLetter()
    }
}
