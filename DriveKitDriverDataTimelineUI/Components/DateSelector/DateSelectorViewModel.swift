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
    private static let calendar = Calendar(identifier: .gregorian)
    private var dates: [Date] = []
    private var period: DKTimelinePeriod = .week
    private var selectedDateIndex: Int = -1
    weak var delegate: DateSelectorDelegate?
    private(set) var hasPreviousDate: Bool = false
    private(set) var hasNextDate: Bool = false
    private(set) var fromDate: Date = Date()
    private(set) var toDate: Date = Date()
    var dateSelectorViewModelDidUpdate: (() -> ())?

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
        self.dateSelectorViewModelDidUpdate?()
    }

    func moveToNextDate() {
        guard hasNextDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex + 1
        self.updateSelectedDateIndex(self.selectedDateIndex)
    }

    func moveToPreviousDate() {
        guard hasPreviousDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex - 1
        self.updateSelectedDateIndex(self.selectedDateIndex)
    }

    func updateSelectedDateIndex(_ selectedDateIndex: Int) {
        self.selectedDateIndex = selectedDateIndex
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
        self.delegate?.dateSelectorDidSelectDate(date)
    }

    private func updateAttributes(selectedDate: Date) {
        self.hasNextDate = (self.dates.count > self.selectedDateIndex + 1)
        self.hasPreviousDate = self.selectedDateIndex > 0
        self.fromDate = selectedDate
        self.toDate = DateSelectorViewModel.getEndDate(fromDate: self.fromDate, period: self.period) ?? Date()
    }

    private static func getEndDate(fromDate: Date, period: DKTimelinePeriod) -> Date? {
        if period == .week {
            return DateSelectorViewModel.calendar.date(byAdding: .day, value: 6, to: fromDate)
        } else {
            guard let nextMonth = DateSelectorViewModel.calendar.date(byAdding: .month, value: 1, to: fromDate) else { return nil }
            return DateSelectorViewModel.calendar.date(byAdding: .day, value: -1, to: nextMonth)
        }
    }

    func getDateIntervalAttributedText() -> NSAttributedString {
        let fromDateString = self.fromDate.format(pattern: .standardDate).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
        let toDateString = self.toDate.format(pattern: .standardDate).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
        let intervalString = "\("dk_timeline_from_date".dkDriverDataTimelineLocalized()) %@ \("dk_timeline_to_date".dkDriverDataTimelineLocalized()) %@".dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.black.withAlphaComponent(0.53)).buildWithArgs(fromDateString, toDateString)
        return intervalString
    }
}
