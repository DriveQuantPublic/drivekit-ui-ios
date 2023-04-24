//
//  DrivingConditionsContextCard+Week.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension DrivingConditionsContextCard {
    func configureAsWeekContext(
        with drivingConditions: DKDriverTimeline.DKDrivingConditions
    ) {
        var weekdaysItem: DrivingConditionsContextItem?
        var weekendItem: DrivingConditionsContextItem?
        totalDistance = drivingConditions.weekdaysDistance + drivingConditions.weekendDistance
        if drivingConditions.weekdaysDistance > 0 {
            weekdaysItem = DrivingConditionsContextItem(
                title: "dk_driverdata_drivingconditions_weekdays".dkDriverDataLocalized(),
                distance: drivingConditions.weekdaysDistance,
                totalDistance: totalDistance,
                baseColor: .level1
            )
        }
        if drivingConditions.weekendDistance > 0 {
            weekendItem = DrivingConditionsContextItem(
                title: "dk_driverdata_drivingconditions_weekend".dkDriverDataLocalized(),
                distance: drivingConditions.weekendDistance,
                totalDistance: totalDistance,
                baseColor: .level2
            )
        }
        self.contextItems = [weekdaysItem, weekendItem].compactMap { $0 }
        self.title = self.title(
            between: ("weekdays", weekdaysItem),
            and: ("weekend", weekendItem),
            l10nTagIfSame: "week"
        )
        self.viewModelDidUpdate?()
    }
}
