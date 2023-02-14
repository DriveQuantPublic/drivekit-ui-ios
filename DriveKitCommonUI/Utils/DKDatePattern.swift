// swiftlint:disable all
//
//  DKDatePattern.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum DKDatePattern {
    case weekLetter,
         standardDate,
         hourMinute,
         hourMinuteLetter,
         fullDate,
         dayMonth,
         dayMonthLetter,
         dayMonthLetterYear,
         yearOnly,
         year,
         dayOfMonth,
         day,
         month,
         monthLetterYear,
         monthAbbreviation

    public var rawValue: String {
        switch self {
            case .weekLetter:
                return "EEEE d MMMM"
            case .standardDate:
                return "dd/MM/yyyy"
            case .hourMinute:
                return "HH:mm"
            case .hourMinuteLetter:
                let hourUnit = DKCommonLocalizable.unitHour.text()
                return "HH'\(hourUnit)'mm"
            case .fullDate:
                return "EEEE d MMMM yyyy"
            case .dayMonth:
                return "dd/MM"
            case .dayMonthLetter:
                return "d MMMM"
            case .dayMonthLetterYear:
                return "d MMMM yyyy"
            case .yearOnly:
                return "E"
            case .year:
                return "yyyy"
            case .dayOfMonth:
                return "d"
            case .day:
                return "EEEE"
            case .month:
                return "M"
            case .monthLetterYear:
                return "MMMM yyyy"
            case .monthAbbreviation:
                return "MMM"
        }
    }
}
