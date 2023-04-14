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
    
    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        var tempItems: [DayNightContextItem] = []
        if drivingConditions.dayDistance > 0 {
            tempItems.append(.day(distance: drivingConditions.dayDistance))
        }
        if drivingConditions.nightDistance > 0 {
            tempItems.append(.night(distance: drivingConditions.nightDistance))
        }
        self.contextItems = tempItems
    }
}

extension DayNightContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        // TODO: to be implemented
        return ""
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
