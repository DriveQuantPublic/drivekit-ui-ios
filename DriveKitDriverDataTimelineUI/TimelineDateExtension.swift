//
//  TimelineDateExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 25/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

extension Date {
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }

    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return self.calendar.startOfDay(for: self)
        }
        let components = dateComponents(for: component)
        guard !components.isEmpty else { return nil }
        return self.calendar.date(from: self.calendar.dateComponents(components, from: self))
    }

    func diffWith(date: Date, count: Calendar.Component) -> Int? {
        let calendar = self.calendar
        let components = dateComponents(for: count)
        let startDateComponents = calendar.dateComponents(components, from: self)
        let endDateComponents = calendar.dateComponents(components, from: date)
        let result = calendar.dateComponents([count], from: startDateComponents, to: endDateComponents)
        return result.value(for: count)
    }

    func date(byAdding value: Int, component: Calendar.Component) -> Date? {
        return self.calendar.date(byAdding: component, value: value, to: self)
    }

    func dateByRemovingTime() -> Date? {
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
