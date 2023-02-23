//
//  DKDriverTimelineExtension.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 20/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation

extension DKDriverTimeline {
    var periodDates: DKDateSelectorViewModel.PeriodDates {
        .init(dates: self.allContext.map(\.date), period: self.period)
    }
}
