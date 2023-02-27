//
//  Helpers.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 16/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

enum Helpers {
    static func newSelectedDate(
        from selectedDate: Date,
        switchingTo nextPeriod: DKPeriod,
        weekTimeline: DKRawTimeline,
        monthTimeline: DKRawTimeline
    ) -> Date {
        guard weekTimeline.period == .week, monthTimeline.period == .month else {
            preconditionFailure("given timeline period are invalid, please check your parameters")
        }
        
        let nextTimeline: DKRawTimeline
        let compareDate: Date?
        var newSelectedDate = selectedDate
        
        switch nextPeriod {
        case .week:
            // Changed from .month to .week
            nextTimeline = weekTimeline
            compareDate = selectedDate
        case .month:
            // Changed from .week to .month
            nextTimeline = monthTimeline
            compareDate = DriveKitDriverDataTimelineUI.calendar.date(from: DriveKitDriverDataTimelineUI.calendar.dateComponents([.year, .month], from: selectedDate))
        @unknown default:
            preconditionFailure("period \(nextPeriod) is not implemented yet")
        }
        
        let dates = nextTimeline.allContext.date
        
        if let compareDate {
            let newDate = dates.first { date in
                date >= compareDate
            }
            if let newDate {
                newSelectedDate = newDate
            }
        }
        
        return newSelectedDate
    }
}
