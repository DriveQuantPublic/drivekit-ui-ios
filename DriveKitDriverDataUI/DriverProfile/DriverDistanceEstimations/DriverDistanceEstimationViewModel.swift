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
    private(set) var hasData: Bool = false

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
        self.hasData = true
        self.viewModelDidUpdate?()
    }

    func configureWithNoData() {
        self.hasData = false
        self.viewModelDidUpdate?()
    }

    var title: String {
        switch period {
            case .week:
                return "dk_driverdata_distance_card_title_week".dkDriverDataLocalized()
            case .month:
                return "dk_driverdata_distance_card_title_month".dkDriverDataLocalized()
            case .year:
                return "dk_driverdata_distance_card_title_year".dkDriverDataLocalized()
        }
    }

    var estimationLegendText: String {
        return "dk_driverdata_distance_card_estimation".dkDriverDataLocalized()
    }

    var realDistanceLegendText: String {
        switch period {
            case .week:
                return "dk_driverdata_distance_card_current_week".dkDriverDataLocalized()
            case .month:
                return "dk_driverdata_distance_card_current_month".dkDriverDataLocalized()
            case .year:
                return "dk_driverdata_distance_card_current_year".dkDriverDataLocalized()
        }
    }

    var estimationPaddingPercent: CGFloat {
        if estimation >= realDistance {
            return 0
        }
        return 1 - CGFloat(estimation) / CGFloat(realDistance)
    }

    var realDistancePaddingPercent: CGFloat {
        if realDistance >= estimation {
            return 0
        }
        return 1 - CGFloat(realDistance) / CGFloat(estimation)
    }
}
