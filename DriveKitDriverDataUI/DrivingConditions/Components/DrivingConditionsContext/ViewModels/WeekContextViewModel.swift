//
//  WeekContextViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class WeekContextViewModel {
    private var contextItems: [WeekContextItem] = []
    var viewModelDidUpdate: (() -> Void)?

    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        var tempItems: [WeekContextItem] = []
        if drivingConditions.weekdaysDistance > 0 {
            tempItems.append(.weekdays(distance: drivingConditions.weekdaysDistance))
        }
        if drivingConditions.weekendDistance > 0 {
            tempItems.append(.weekend(distance: drivingConditions.weekendDistance))
        }
        self.contextItems = tempItems
        self.viewModelDidUpdate?()
    }
}

extension WeekContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        let weekdaysItem = contextItems.first { item in
            switch item {
                case .weekdays:
                    return true
                case .weekend:
                    return false
            }
        }
        guard let weekdaysItem = weekdaysItem else {
            return "dk_driverdata_drivingconditions_main_weekend".dkDriverDataLocalized()
        }
        let weekdaysPercent = self.getContextPercent(weekdaysItem)
        let minPercent = 0.45
        let maxPercent = 0.55
        if weekdaysPercent < minPercent {
            return "dk_driverdata_drivingconditions_main_weekend".dkDriverDataLocalized()
        } else if weekdaysPercent > maxPercent {
            return "dk_driverdata_drivingconditions_main_weekdays".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_drivingconditions_all_week".dkDriverDataLocalized()
        }
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? WeekContextItem else {
            return 0
        }
        let totalDistance = self.contextItems.reduce(0) {
            $0 + $1.distance
        }
        return contextItem.distance / totalDistance
    }

    func contextCard(_ updateCompletionHandler: (() -> Void)?) {
        self.viewModelDidUpdate = updateCompletionHandler
    }
}

enum WeekContextItem {
    case weekdays(distance: Double)
    case weekend(distance: Double)

    var distance: Double {
        switch self {
            case .weekdays(let distance):
                return distance
            case .weekend(let distance):
                return distance
        }
    }
}

extension WeekContextItem: DKContextItem {
    var color: UIColor {
        switch self {
            case .weekdays:
                return DKContextCardColor.level1.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .weekend:
                return DKContextCardColor.level3.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
        }
    }
    
    var title: String {
        switch self {
            case .weekdays:
                return "dk_driverdata_weekdays".dkDriverDataLocalized()
            case .weekend:
                return "dk_driverdata_weekend".dkDriverDataLocalized()
        }
    }
    
    var subtitle: String? {
        switch self {
            case .weekdays(let distance):
                return distance.formatKilometerDistance()
            case .weekend(let distance):
                return distance.formatKilometerDistance()
        }
    }
}
