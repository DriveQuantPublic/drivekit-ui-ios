//
//  DateSelectorViewModel.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

public class DateSelectorViewModel {
    private static let calendar = Calendar(identifier: .gregorian)
    private var dates: [Date]
    private var period: DKPeriod
    private var selectedDateIndex: Int
    public weak var delegate: DateSelectorDelegate?
    private(set) var hasPreviousDate: Bool
    private(set) var hasNextDate: Bool
    private(set) var fromDate: Date
    private(set) var toDate: Date
    var dateSelectorViewModelDidUpdate: (() -> Void)?

    public var selectedDate: Date {
        get {
            guard selectedDateIndex < self.dates.count, selectedDateIndex >= 0 else {
                assertionFailure("We should have a valid selectedDateIndex (current is \(selectedDateIndex), should be in 0..<\(self.dates.count))")
                return Date()
            }
            return self.dates[self.selectedDateIndex]
        }
        set {
            guard let newSelectedDateIndex = self.dates.firstIndex(where: { $0 == newValue }) else {
                assertionFailure("SelectedDate \(newValue) must be inside dates list \(dates)")
                return
            }
            
            self.selectedDateIndex = newSelectedDateIndex
        }
    }
    
    public init() {
        self.dates = []
        self.period = .week
        self.selectedDateIndex = -1
        self.delegate = nil
        self.hasPreviousDate = false
        self.hasNextDate = false
        self.fromDate = Date()
        self.toDate = Date()
        self.dateSelectorViewModelDidUpdate = nil
    }

    public func configure(dates: [Date], period: DKPeriod = .week, selectedIndex: Int? = nil) {
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
        self.selectedDateIndex += 1
        self.updateSelectedDateIndex(self.selectedDateIndex)
    }

    func moveToPreviousDate() {
        guard hasPreviousDate else {
            return
        }
        self.selectedDateIndex -= 1
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

    private static func getEndDate(fromDate: Date, period: DKPeriod) -> Date? {
        if period == .week {
            let numberOfWeekDays = 7
            return DateSelectorViewModel.calendar.date(
                byAdding: .day,
                value: numberOfWeekDays - 1,
                to: fromDate
            )
        } else {
            guard let nextMonth = DateSelectorViewModel.calendar.date(
                byAdding: .month,
                value: 1,
                to: fromDate
            ) else { return nil }
            return DateSelectorViewModel.calendar.date(
                byAdding: .day,
                value: -1,
                to: nextMonth
            )
        }
    }

    func getDateIntervalAttributedText() -> NSAttributedString {
        switch self.period {
            case .week:
                return weekDateIntervalAttributedText()
            case .month:
                return monthDateIntervalAttributedText()
            case .year:
                return yearDateIntervalAttributedText()
            @unknown default:
                fatalError("Unknown case")
        }
    }

    private func weekDateIntervalAttributedText() -> NSAttributedString {
        guard
            let fromDateMonth = Calendar.current.dateComponents([.month], from: self.fromDate).month,
            let toDateMonth = Calendar.current.dateComponents([.month], from: self.toDate).month
        else {
            assertionFailure("We should have month for both date or we have a problem, Houston")
            return "".dkAttributedString().build()
        }
        
        if fromDateMonth == toDateMonth {
            return "\(self.fromDate.format(pattern: .dayOfMonth)) - \(self.toDate.format(pattern: .dayMonthLetterYear))"
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine1)
                .color(.primaryColor)
                .build()
        } else {
            return "\(self.fromDate.format(pattern: .dayMonthLetter)) - \(self.toDate.format(pattern: .dayMonthLetterYear))"
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine1)
                .color(.primaryColor)
                .build()
        }
    }

    private func monthDateIntervalAttributedText() -> NSAttributedString {
        return self.fromDate
            .format(pattern: .monthLetterYear)
            .capitalizeFirstLetter()
            .dkAttributedString()
            .font(dkFont: .primary, style: .headLine1)
            .color(.primaryColor)
            .build()
    }
    
    private func yearDateIntervalAttributedText() -> NSAttributedString {
        return self.fromDate
            .format(pattern: .year)
            .dkAttributedString()
            .font(dkFont: .primary, style: .headLine1)
            .color(.primaryColor)
            .build()
    }
}

extension DateSelectorViewModel {
    public struct PeriodDates {
        public var dates: [Date]
        public var period: DKPeriod
        
        public init(
            dates: [Date] = [],
            period: DKPeriod
        ) {
            self.dates = dates
            self.period = period
        }
    }
    
    public static func newSelectedDate(
        from selectedDate: Date,
        in currentPeriodDates: PeriodDates,
        switchingTo nextPeriodDates: PeriodDates
    ) -> Date {
        let compareDate: Date?
        var newSelectedDate = selectedDate
        
        switch (currentPeriodDates.period, nextPeriodDates.period) {
            case (.month, .week),
                (.year, .week),
                (.year, .month):
                compareDate = selectedDate
            case (.week, .month):
                compareDate = DriveKitUI.calendar.date(
                    from: DriveKitUI.calendar.dateComponents(
                        [.year, .month],
                        from: selectedDate
                    )
                )
            case (.week, .year),
                (.month, .year):
                compareDate = DriveKitUI.calendar.date(
                    from: DriveKitUI.calendar.dateComponents(
                        [.year],
                        from: selectedDate
                    )
                )
            case (.week, .week),
                (.month, .month),
                (.year, .year):
                compareDate = nil
        }
        
        let dates = nextPeriodDates.dates
        
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
