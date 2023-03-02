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

public extension DKDriverTimeline {
    var periodDates: DKDateSelectorViewModel.PeriodDates {
        .init(dates: self.allContext.map(\.date), period: self.period)
    }
}

extension DKDriverTimeline.DKAllContextItem {
    var hasOnlyShortTrips: Bool {
        self.numberTripScored == 0 && self.numberTripTotal > 0
    }
}
