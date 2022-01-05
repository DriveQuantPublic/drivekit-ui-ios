//
//  ActivationHoursDayCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Jad on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule

class ActivationHoursDayCellViewModel {
    typealias Input = (String, Int, Int)

    private struct Constants {
        static let hours: Double = 24
        static let defaultStart: Double = 8
        static let defaultEnd: Double = 18
        static let sliderStart: Double = 0
        static let sliderEnd: Double = 24

        struct CodingKey {
            static let selection = "selection"
            static let min = "min"
            static let max = "max"
            static let index = "index"
        }

        struct Wording {
            static let weekdaySymbolByDay: [DKDay: String] = DateFormatter().weekdaySymbolByDay()
            static let hourFormatter = "h00"
            static let halfHourFormatter = "h30"
        }
    }

    let day: DKDay
    var isSelected = false
    var min: Double = 1 / Constants.hours * Constants.defaultStart
    var max: Double = 1 / Constants.hours * Constants.defaultEnd
    var text: String {
        return Constants.Wording.weekdaySymbolByDay[self.day] ?? ""
    }
    var minFormattedValue: String {
        return hourFormatter(sliderValue: self.min).0
    }
    var maxFormattedValue: String {
        return hourFormatter(sliderValue: self.max).0
    }

    init(day: DKDay, selected: Bool = true) {
        self.day = day
        self.isSelected = selected
    }

    private func hourFormatter(sliderValue: Double) -> Input {
        let step = Double(1 / (Constants.sliderEnd - Constants.sliderStart))
        let computedHour = sliderValue / step

        let roundedValue = computedHour.round(nearest: 0.5)

        let fl = floor(roundedValue)

        let isInteger = fl == roundedValue

        let floorValue = String(Int(fl))
        if isInteger {
            return (floorValue + Constants.Wording.hourFormatter, Int(fl), 0)
        }
        return (floorValue + Constants.Wording.halfHourFormatter, Int(fl), 30)
    }
}

extension ActivationHoursDayCellViewModel {
    func dateFromSliderValue(sliderValue: Double, date: Date) -> Date {
        let components = hourFormatter(sliderValue: sliderValue)
        let result = dateFromComponents(input: components, date: date)
        return result
    }

    func dateFromComponents(input: Input, date: Date) -> Date{
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        dateComponents.hour = input.1
        dateComponents.minute = input.2
        return Calendar.current.date(from: dateComponents)!
    }
}

extension Double {
    func round(nearest: Double) -> Double {
        let n = 1 / nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
}

extension DateFormatter {
    func weekdaySymbolByDay() -> [DKDay: String] {
        let weekdaySymbolByDay: [DKDay: String]
        if let days = self.shortWeekdaySymbols {
            weekdaySymbolByDay = [
                .sunday: days[0],
                .monday: days[1],
                .tuesday: days[2],
                .wednesday: days[3],
                .thursday: days[4],
                .friday: days[5],
                .saturday: days[6]
            ]
        } else {
            weekdaySymbolByDay = [
                .sunday: "SUN",
                .monday: "MON",
                .tuesday: "TUE",
                .wednesday: "WED",
                .thursday: "THU",
                .friday: "FRI",
                .saturday: "SAT"
            ]
        }
        return weekdaySymbolByDay
    }
}
