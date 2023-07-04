//
//  DriverDistanceEstimationViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitDBTripAccessModule

class DriverDistanceEstimationViewModel {
    private(set) var period: DKPeriod
    var viewModelDidUpdate: (() -> Void)?
    private(set) var estimation: Int = 0
    private(set) var realDistance: Int = 0

    init(period: DKPeriod) {
        self.period = period
    }
    
    func configure(with distanceEstimation: DKDriverDistanceEstimation, and currentDrivenDistances: [DKPeriod: Double]) {
        self.realDistance = Int(currentDrivenDistances[period] ?? 0)
        switch period {
            case .week:
                self.estimation = distanceEstimation.weekDistance
            case .month:
                self.estimation = distanceEstimation.monthDistance
            case .year:
                self.estimation = distanceEstimation.yearDistance
        }
        self.viewModelDidUpdate?()
    }
    
    func configureWithNoData() {
        #warning("TODO: implement view model update")
        self.viewModelDidUpdate?()
    }
}
