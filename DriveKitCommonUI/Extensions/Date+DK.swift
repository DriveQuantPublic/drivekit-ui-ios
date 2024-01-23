//
//  Date+DK.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 25/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension Date {
    public var calendar: Calendar {
        var calendar = DriveKitUI.calendar
        let monday = 2
        calendar.firstWeekday = monday
        return calendar
    }

    public var startOfWeek: Date? {
        let monday = 2
        return calendar.nextDate(
            after: self,
            matching: .init(
                calendar: calendar,
                timeZone: .current,
                weekday: monday
            ),
            matchingPolicy: .nextTime,
            direction: .backward
        )
    }
    
    public var endOfWeek: Date? {
        let sunday = 1
        return calendar.nextDate(
            after: self,
            matching: .init(
                calendar: calendar,
                timeZone: .current,
                weekday: sunday
            ),
            matchingPolicy: .nextTime
        )
    }
    
    public var endOfMonth: Date? {
        let currentMonth = calendar.component(.month, from: self)
        let december = 12
        let january = 1
        let nextMonth = currentMonth == december ? january : currentMonth + 1
        guard
            let startOfNextMonth = calendar.nextDate(
                after: self,
                matching: .init(
                    calendar: calendar,
                    timeZone: .current,
                    month: nextMonth,
                    day: 1
                ),
                matchingPolicy: .nextTime
            )
        else {
            return nil
        }
        return calendar.date(byAdding: .day, value: -1, to: startOfNextMonth)
    }
    
    public var endOfYear: Date? {
        let currentYear = calendar.component(.year, from: self)
        let december = 12
        let lastDayOfDecember = 31
        let lastHour = 23
        let lastMinuteSecond = 59
        return calendar.nextDate(
            after: self,
            matching: .init(
                calendar: calendar,
                timeZone: .current,
                year: currentYear,
                month: december,
                day: lastDayOfDecember,
                hour: lastHour,
                minute: lastMinuteSecond,
                second: lastMinuteSecond
            ),
            matchingPolicy: .nextTime
        )
    }
    
    public func beginning(relativeTo component: Calendar.Component) -> Date? {
        if component == .day {
            return self.calendar.startOfDay(for: self)
        }
        let components = dateComponents(for: component)
        guard !components.isEmpty else { return nil }
        return self.calendar.date(from: self.calendar.dateComponents(components, from: self))
    }

    public func diffWith(date: Date, countingIn calendarUnit: Calendar.Component) -> Int? {
        let calendar = self.calendar
        let components = dateComponents(for: calendarUnit)
        let startDateComponents = calendar.dateComponents(components, from: self)
        let endDateComponents = calendar.dateComponents(components, from: date)
        let result = calendar.dateComponents([calendarUnit], from: startDateComponents, to: endDateComponents)
        return result.value(for: calendarUnit)
    }

    public func date(byAdding value: Int, calendarUnit: Calendar.Component) -> Date? {
        return self.calendar.date(byAdding: calendarUnit, value: value, to: self)
    }

    public func dateByRemovingTime() -> Date? {
        return self.calendar.date(from: self.calendar.dateComponents([.year, .month, .day], from: self))
    }

    private func dateComponents(for component: Calendar.Component) -> Set<Calendar.Component> {
        switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]
            case .minute:
                return [.year, .month, .day, .hour, .minute]
            case .hour:
                return [.year, .month, .day, .hour]
            case .day:
                return [.year, .month, .day]
            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]
            case .month:
                return [.year, .month]
            case .year:
                return [.year]
            default:
                return []
        }
    }
}
