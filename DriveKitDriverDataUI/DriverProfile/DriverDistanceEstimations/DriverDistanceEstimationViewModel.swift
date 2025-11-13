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
import DriveKitCommonUI

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
        let distanceFactor: Double
        if DriveKitUI.shared.unitSystem == .imperial {
            distanceFactor = Measurement(value: 1, unit: UnitLength.kilometers).converted(to: .miles).value
        } else {
            distanceFactor = 1
        }
        self.realDistance = Int(((currentDrivenDistances[period] ?? 0) * distanceFactor).rounded())
        switch period {
            case .week:
                self.estimation = Int((Double(distanceEstimation.weekDistance) * distanceFactor).rounded())
            case .month:
                self.estimation = Int((Double(distanceEstimation.monthDistance) * distanceFactor).rounded())
            case .year:
                self.estimation = Int((Double(distanceEstimation.yearDistance) * distanceFactor).rounded())
            @unknown default:
                self.estimation = Int((Double(distanceEstimation.yearDistance) * distanceFactor).rounded())
        }
        self.hasData = true
        self.viewModelDidUpdate?()
    }

    func configureWithNoData() {
        self.hasData = false
        self.viewModelDidUpdate?()
    }

    var title: String {
        let useImperialUnit = DriveKitUI.shared.unitSystem == .imperial
        switch period {
            case .week:
                let key = useImperialUnit ? "dk_driverdata_distance_card_title_week_miles" : "dk_driverdata_distance_card_title_week"
                return key.dkDriverDataLocalized()
            case .month:
                let key = useImperialUnit ? "dk_driverdata_distance_card_title_month_miles" : "dk_driverdata_distance_card_title_month"
                return key.dkDriverDataLocalized()
            case .year:
                let key = useImperialUnit ? "dk_driverdata_distance_card_title_year_miles" : "dk_driverdata_distance_card_title_year"
                return key.dkDriverDataLocalized()
            @unknown default:
                return ""
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
            @unknown default:
                return ""
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
