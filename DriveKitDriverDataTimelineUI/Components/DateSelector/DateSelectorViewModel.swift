//
//  DateSelectorViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitDBTripAccessModule

class DateSelectorViewModel {
    private var dates: [Date] = []
    private var period: DKTimelinePeriod = .week
    private var selectedDateIndex: Int = -1
    var delegates: WeakArray<DateSelectorDelegate> = WeakArray()
    private(set) var hasPerviousDate: Bool = false
    private(set) var hasNextDate: Bool = false
    private(set) var fromDate: Date = Date()
    private(set) var toDate: Date = Date()

    private var selectedDate: Date {
        guard selectedDateIndex < self.dates.count, selectedDateIndex >= 0 else {
            return Date()
        }
        return self.dates[self.selectedDateIndex]
    }

    func update(dates: [Date], period: DKTimelinePeriod = .week, selectedIndex: Int? = nil) {
        self.dates = dates
        self.period = period
        self.selectedDateIndex = selectedIndex ?? dates.count - 1
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
        for delegate in self.delegates {
            delegate?.dateSelectorUpdated()
        }
    }

    func moveToNextDate() {
        guard hasNextDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex + 1
        self.updateSelectedDateIndex(selectedIndex: self.selectedDateIndex)
    }

    func moveToPreviousDate() {
        guard hasPerviousDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex - 1
        self.updateSelectedDateIndex(selectedIndex: self.selectedDateIndex)
    }

    func updateSelectedDateIndex(selectedIndex: Int) {
        self.selectedDateIndex = selectedIndex
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
        for delegate in self.delegates {
            delegate?.dateSelectorDidSelectDate(date)
        }
    }

    private func updateAttributes(selectedDate: Date) {
        self.hasNextDate = (self.dates.count > self.selectedDateIndex + 1)
        self.hasPerviousDate = self.selectedDateIndex > 0
        self.fromDate = selectedDate
        self.toDate = DateSelectorViewModel.getEndDate(fromDate: self.fromDate, period: self.period) ?? Date()
    }

    private static func getEndDate(fromDate: Date, period: DKTimelinePeriod) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        if period == .week {
            return calendar.date(byAdding: .day, value: 6, to: fromDate)
        } else {
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: fromDate) else { return nil }
            return calendar.date(byAdding: .day, value: -1, to: nextMonth)
        }
    }

    func getDateIntervalAttributedText() -> NSAttributedString {
        let fromDateString = self.fromDate.format(pattern: .standardDate).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
        let toDateString = self.toDate.format(pattern: .standardDate).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
        let intervalString = "\("dk_timeline_from_date".dkDriverDataTimelineLocalized()) %@ \("dk_timeline_to_date".dkDriverDataTimelineLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.black.withAlphaComponent(0.53)).buildWithArgs(fromDateString, toDateString)
        return intervalString
    }
}
