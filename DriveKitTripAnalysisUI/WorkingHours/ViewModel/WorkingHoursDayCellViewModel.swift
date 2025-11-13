// swiftlint:disable no_magic_numbers
//
//  WorkingHoursDayCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Jad on 31/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import Foundation

class WorkingHoursDayCellViewModel {
    // swiftlint:disable:next large_tuple
    typealias Input = (String, Int, Int)

    private enum Constants {
        static let hours: Double = 24
        static let sliderStart: Double = 0
        static let sliderEnd: Double = 24

        enum Wording {
            static let weekdaySymbolByDay: [DKDay: String] = DateFormatter().weekdaySymbolByDay()
            static let hourFormatter = ":00"
            static let halfHourFormatter = ":30"
            static let maxHour = "23:59"
        }
    }

    private let config: DKWorkingHoursDayConfiguration
    var isSelected: Bool {
        didSet {
            if config.entireDayOff != !isSelected {
                config.entireDayOff = !isSelected
                self.delegate?.workingHoursDayCellViewModelDidUpdate(self)
            }
        }
    }
    var min: Double {
        didSet {
            let startTime = getTime(fromSliderValue: self.min)
            if config.startTime != startTime {
                config.startTime = startTime
                self.delegate?.workingHoursDayCellViewModelDidUpdate(self)
            }
        }
    }
    var max: Double {
        didSet {
            let endTime = getTime(fromSliderValue: self.max)
            if config.endTime != endTime {
                config.endTime = endTime
                self.delegate?.workingHoursDayCellViewModelDidUpdate(self)
            }
        }
    }
    var text: String {
        return Constants.Wording.weekdaySymbolByDay[self.config.day] ?? ""
    }
    var minFormattedValue: String {
        let value = isSelected ? self.min : 0
        return hourFormatter(sliderValue: value).0
    }
    var maxFormattedValue: String {
        let value = isSelected ? self.max : 1
        return hourFormatter(sliderValue: value).0
    }
    weak var delegate: WorkingHoursDayCellViewModelDelegate?

    init(config: DKWorkingHoursDayConfiguration) {
        self.config = config
        self.isSelected = !config.entireDayOff
        self.min = 1 / Constants.hours * config.startTime
        self.max = 1 / Constants.hours * config.endTime
    }

    private func hourFormatter(sliderValue: Double) -> Input {
        let step = Double(1 / (Constants.sliderEnd - Constants.sliderStart))
        let computedHour = sliderValue / step

        let roundedValue = computedHour.round(nearest: 0.5)

        let fl = floor(roundedValue)

        let isInteger = fl == roundedValue

        if fl == 24.0 {
            return (Constants.Wording.maxHour, Int(fl), 0)
        }

        let floorValue = String(format: "%02i", Int(fl) % 24)
        if isInteger {
            return (floorValue + Constants.Wording.hourFormatter, Int(fl), 0)
        }
        return (floorValue + Constants.Wording.halfHourFormatter, Int(fl), 30)
    }

    private func getTime(fromSliderValue sliderValue: Double) -> Double {
        let rawTime = sliderValue * Constants.hours
        return rawTime.round(nearest: 0.5)
    }
}

protocol WorkingHoursDayCellViewModelDelegate: AnyObject {
    func workingHoursDayCellViewModelDidUpdate(_ workingHoursDayCellViewModel: WorkingHoursDayCellViewModel)
}

extension WorkingHoursDayCellViewModel {
    func dateFromComponents(input: Input, date: Date) -> Date {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        dateComponents.hour = input.1
        dateComponents.minute = input.2
        return Calendar.current.date(from: dateComponents)!
    }
}

extension Double {
    func round(nearest: Double) -> Double {
        let coeff = 1 / nearest
        let numberToRound = self * coeff
        return numberToRound.rounded() / coeff
    }
}

extension DateFormatter {
    func weekdaySymbolByDay() -> [DKDay: String] {
        let weekdaySymbolByDay: [DKDay: String]
        if let days = self.shortWeekdaySymbols {
            weekdaySymbolByDay = [
                .sunday: days[0].uppercased(),
                .monday: days[1].uppercased(),
                .tuesday: days[2].uppercased(),
                .wednesday: days[3].uppercased(),
                .thursday: days[4].uppercased(),
                .friday: days[5].uppercased(),
                .saturday: days[6].uppercased()
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
