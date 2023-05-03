//
//  DrivingConditionsContextCard+DayNight.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 11/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import UIKit

extension DrivingConditionsContextCard {
    func configureAsDayNightContext(
        with drivingConditions: DKDriverTimeline.DKDrivingConditions
    ) {
        var dayItem: DrivingConditionsContextItem?
        var nightItem: DrivingConditionsContextItem?
        totalItemsValue = drivingConditions.dayDistance + drivingConditions.nightDistance
        if drivingConditions.dayDistance > 0 {
            dayItem = DrivingConditionsContextItem(
                title: "dk_driverdata_drivingconditions_day".dkDriverDataLocalized(),
                itemValue: drivingConditions.dayDistance,
                totalItemsValue: totalItemsValue,
                baseColor: .level1
            )
        }
        if drivingConditions.nightDistance > 0 {
            nightItem = DrivingConditionsContextItem(
                title: "dk_driverdata_drivingconditions_night".dkDriverDataLocalized(),
                itemValue: drivingConditions.nightDistance,
                totalItemsValue: totalItemsValue,
                baseColor: .level2
            )
        }
        self.contextItems = [dayItem, nightItem].compactMap { $0 }
        self.title = self.title(
            between: ("day", dayItem),
            and: ("night", nightItem),
            l10nTagIfSame: "day"
        )
        self.viewModelDidUpdate?()
    }
}
