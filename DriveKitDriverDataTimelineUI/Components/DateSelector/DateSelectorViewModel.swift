//
//  DateSelectorViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class DateSelectorViewModel {
    private var dates: [Date] = []
    private var period: DKTimelinePeriod = .week
    private var selectedDateIndex: Int = -1
    weak var delegate: DateSelectorDelegate?
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

    func update(dates: [Date], period: DKTimelinePeriod = .week) {
        self.dates = dates
        self.period = period
        self.selectedDateIndex = dates.count - 1
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
    }

    func moveToNextDate() {
        guard hasNextDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex + 1
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
        self.delegate?.dateSelectorDidSelectDate(date)
    }

    func moveToPreviousDate() {
        guard hasPerviousDate else {
            return
        }
        self.selectedDateIndex = self.selectedDateIndex - 1
        let date = self.selectedDate
        self.updateAttributes(selectedDate: date)
        self.delegate?.dateSelectorDidSelectDate(date)
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
            return calendar.date(byAdding: .day, value: 7, to: fromDate)
        } else {
            return calendar.date(byAdding: .month, value: 1, to: fromDate)
        }
    }
}
