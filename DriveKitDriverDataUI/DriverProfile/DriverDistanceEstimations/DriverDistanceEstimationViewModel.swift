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
    var viewModelDidUpdate: (() -> Void)?

    init(period: DKPeriod) {
        self.period = period
    }
    
    func configure() {
        #warning("TODO: implement view model update")
        self.viewModelDidUpdate?()
    }
    
    func configureWithNoData() {
        #warning("TODO: implement view model update")
        self.viewModelDidUpdate?()
    }
}
