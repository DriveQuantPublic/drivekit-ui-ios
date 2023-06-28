//
//  DriverDistanceEstimationViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

class DriverDistanceEstimationViewModel {
    var period: DKPeriod

    init(period: DKPeriod) {
        self.period = period
    }
}
