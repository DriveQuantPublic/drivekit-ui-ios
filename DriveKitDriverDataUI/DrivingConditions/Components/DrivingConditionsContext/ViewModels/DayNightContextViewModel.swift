//
//  DayNightContextViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 11/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class DayNightContextViewModel {
    var drivingConditions: DKDriverTimeline.DKDrivingConditions?
    private var contextItems: [DayNightContextItem] = []
    var viewModelDidUpdate: (() -> Void)?

    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        var tempItems: [DayNightContextItem] = []
        if drivingConditions.dayDistance > 0 {
            tempItems.append(.day(distance: drivingConditions.dayDistance))
        }
        if drivingConditions.nightDistance > 0 {
            tempItems.append(.night(distance: drivingConditions.nightDistance))
        }
        self.contextItems = tempItems
        self.viewModelDidUpdate?()
    }
}

extension DayNightContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        let nightItem = contextItems.first { item in
            switch item {
                case .day:
                    return false
                case .night:
                    return true
            }
        }
        guard let nightItem = nightItem else {
            return "dk_driverdata_drivingconditions_main_day".dkDriverDataLocalized()
        }
        let nightPercent = self.getContextPercent(nightItem)
        let minPercent = 0.45
        let maxPercent = 0.55
        if nightPercent < minPercent {
            return "dk_driverdata_drivingconditions_main_day".dkDriverDataLocalized()
        } else if nightPercent > maxPercent {
            return "dk_driverdata_drivingconditions_main_night".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_drivingconditions_all_day".dkDriverDataLocalized()
        }
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? DayNightContextItem else {
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

enum DayNightContextItem {
    case day(distance: Double)
    case night(distance: Double)

    // swiftlint:disable no_magic_numbers
    private static let dayColor = UIColor(hex: 0x036A82).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let nightColor = UIColor(hex: 0x699DAD).tinted(usingHueOf: DKUIColors.primaryColor.color)
    // swiftlint:enable no_magic_numbers

    var distance: Double {
        switch self {
            case .day(let distance):
                return distance
            case .night(let distance):
                return distance
        }
    }
}

extension DayNightContextItem: DKContextItem {
    var color: UIColor {
        switch self {
            case .day:
                return DayNightContextItem.dayColor
            case .night:
                return DayNightContextItem.nightColor
        }
    }
    
    var title: String {
        switch self {
            case .day:
                return "dk_driverdata_day".dkDriverDataLocalized()
            case .night:
                return "dk_driverdata_night".dkDriverDataLocalized()
        }
    }
    
    var subtitle: String? {
        switch self {
            case .day(let distance):
                return distance.formatKilometerDistance()
            case .night(let distance):
                return distance.formatKilometerDistance()
        }
    }
}