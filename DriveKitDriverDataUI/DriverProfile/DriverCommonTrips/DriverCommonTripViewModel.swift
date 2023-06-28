//
//  DriverCommonTripViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

class DriverCommonTripViewModel {
    var commonTripType: DKCommonTripType

    init(commonTripType: DKCommonTripType) {
        self.commonTripType = commonTripType
    }
}
