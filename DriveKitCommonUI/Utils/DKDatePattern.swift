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
    yearOnly,
    year,
    day,
    month

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
            case .yearOnly:
                return "E"
            case .year:
                return "yyyy"
            case .day:
                return "EEEE"
            case .month:
                return "M"
        }
    }
}
