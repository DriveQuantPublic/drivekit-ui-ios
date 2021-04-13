//
//  DKDataFormatter.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public enum FormatType {
    case value(String)
    case unit(String)
    case separator(String = String.nonBreakableSpace)

    var string: String {
        switch self {
            case let .unit(string),
                 let .value(string),
                 let .separator(string):
                return string
        }
    }
}

extension Array where Element == FormatType {
    func toString() -> String {
        reduce(into: "") { (result, formatType) in
            result.append(formatType.string)
        }
    }
}

public extension Double {

    func getMeterDistanceInKmFormat(appendingUnit appendUnit: Bool = true) -> [FormatType] {
        return (self / 1000.0).getKilometerDistanceFormat(appendingUnit: appendUnit)
    }

    func formatMeterDistanceInKm(appendingUnit appendUnit: Bool = true) -> String {
        return getMeterDistanceInKmFormat(appendingUnit: appendUnit).toString()
    }

    func getMeterDistanceFormat() -> [FormatType] {
        let formattingTypes: [FormatType]
        if self < 10 {
            formattingTypes = [
                .value(format(maximumFractionDigits: 2)),
                .separator(),
                .unit(DKCommonLocalizable.unitMeter.text())
            ]
        } else if self < 1000 {
            formattingTypes = [
                .value(format(maximumFractionDigits: 0)),
                .separator(),
                .unit(DKCommonLocalizable.unitMeter.text())
            ]
        } else {
            formattingTypes = getMeterDistanceInKmFormat()
        }
        return formattingTypes
    }

    func formatMeterDistance() -> String {
        return getMeterDistanceFormat().toString()
    }

    func getKilometerDistanceFormat(appendingUnit appendUnit: Bool = true) -> [FormatType] {
        var formattingTypes: [FormatType] = []
        let formattedDistance: String
        if self < 100 {
            formattedDistance = self.format(maximumFractionDigits: 1)
        } else {
            formattedDistance = String(Int(self.rounded()))
        }
        formattingTypes.append(.value(formattedDistance))
        if appendUnit {
            formattingTypes.append(.separator())
            formattingTypes.append(.unit(DKCommonLocalizable.unitKilometer.text()))
        }
        return formattingTypes
    }

    func formatKilometerDistance(appendingUnit appendUnit: Bool = true) -> String {
        getKilometerDistanceFormat(appendingUnit: appendUnit).toString()
    }

    func metersToKilometers(places: Int) -> Double {
        let km = self / 1000.0
        return km.round(places: places)
    }


    func getMassFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(format(maximumFractionDigits: 0)),
            .separator(),
            .unit(DKCommonLocalizable.unitKilogram.text())
        ]
        return formattingTypes
    }

    func formatMass() -> String {
        return getMassFormat().toString()
    }

    func getMassInTonFormat() -> [FormatType] {
        let massInTon = self / 1000.0
        let formattedMass = massInTon.format(maximumFractionDigits: 1)
        let formattingTypes: [FormatType] = [
            .value(formattedMass),
            .separator(),
            .unit(DKCommonLocalizable.unitTon.text())
        ]
        return formattingTypes
    }

    func formatMassInTon() -> String {
        return getMassInTonFormat().toString()
    }


    func getPowerFormat() -> [FormatType] {
        let formattedPower = self.format(maximumFractionDigits: 0)
        let formattingTypes: [FormatType] = [
            .value(formattedPower),
            .separator(),
            .unit(DKCommonLocalizable.unitPower.text())
        ]
        return formattingTypes
    }

    func formatPower() -> String {
        getPowerFormat().toString()
    }


    func round(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func format(maximumFractionDigits: Int = 0, minimumFractionDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) ?? {
            let format = String(format: "%%.%if", maximumFractionDigits)
            return String(format: format, round(places: maximumFractionDigits))
        }()
        return formattedNumber
    }

    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }


    func getSecondDurationFormat() -> [FormatType] {
        let formattingTypes: [FormatType]
        var nbMinute = 0
        var nbHour = 0
        var nbDay = 0
        if self <= 59 {
            formattingTypes = [
                .value(String(Int(self))),
                .separator(),
                .unit(DKCommonLocalizable.unitSecond.text())
            ]
        } else {
            nbMinute = Int((self / 60).rounded(.up))
            if nbMinute > 59 {
                nbHour = nbMinute / 60
                nbMinute = nbMinute - (nbHour * 60)
                if nbHour > 23 {
                    nbDay = nbHour / 24
                    nbHour = nbHour - (24 * nbDay)
                    formattingTypes = [
                        .value(String(nbDay)),
                        .unit(DKCommonLocalizable.unitDay.text()),
                        .separator(),
                        .value(String(nbHour)),
                        .unit(DKCommonLocalizable.unitHour.text())
                    ]
                } else {
                    formattingTypes = [
                        .value(String(nbHour)),
                        .unit(DKCommonLocalizable.unitHour.text()),
                        .value(String(nbMinute))
                    ]
                }
            } else {
                let nbSecond = Int(self - 60.0 * Double(Int(self / 60)))
                if nbSecond > 0 {
                    formattingTypes = [
                        .value(String(nbMinute - 1)),
                        .unit(DKCommonLocalizable.unitMinute.text()),
                        .value(String(nbSecond))
                    ]
                } else {
                    formattingTypes = [
                        .value(String(nbMinute)),
                        .separator(),
                        .unit(DKCommonLocalizable.unitMinute.text())
                    ]
                }
            }
        }
        return formattingTypes
    }

    func formatSecondDuration() -> String {
        return getSecondDurationFormat().toString()
    }


    func getCO2MassFormat() -> [FormatType] {
        let formattingTypes: [FormatType]
        if self < 1 {
            formattingTypes = [
                .value((self * 1000).format(maximumFractionDigits: 0)),
                .separator(),
                .unit(DKCommonLocalizable.unitGram.text())
            ]
        } else {
            formattingTypes = [
                .value(self.format(maximumFractionDigits: 2)),
                .separator(),
                .unit(DKCommonLocalizable.unitKilogram.text())
            ]
        }
        return formattingTypes
    }

    func formatCO2Mass() -> String {
        return getCO2MassFormat().toString()
    }

    func getCO2Emission() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 0)),
            .separator(),
            .unit(DKCommonLocalizable.unitGperKM.text())
        ]
        return formattingTypes
    }

    func formatCO2Emission() -> String {
        return getCO2Emission().toString()
    }


    func getSpeedMeanFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 0)),
            .separator(),
            .unit(DKCommonLocalizable.unitKmPerHour.text())
        ]
        return formattingTypes
    }

    func formatSpeedMean() -> String {
        return getSpeedMeanFormat().toString()
    }


    func getConsumptionFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 1)),
            .separator(),
            .unit(DKCommonLocalizable.unitLPer100Km.text())
        ]
        return formattingTypes
    }

    func formatConsumption() -> String {
        return getConsumptionFormat().toString()
    }


    func getAccelerationFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 2)),
            .separator(),
            .unit(DKCommonLocalizable.unitAcceleration.text())
        ]
        return formattingTypes
    }

    func formatAcceleration() -> String {
        getAccelerationFormat().toString()
    }


    func formatDouble(places: Int) -> String {
        return self.format(maximumFractionDigits: places)
    }

    func formatDouble(fractionDigits: Int) -> String {
        return self.format(maximumFractionDigits: fractionDigits, minimumFractionDigits: fractionDigits)
    }

    var asDate: Date {
        return Date(timeIntervalSince1970: self)
    }

    func ceilSecondDuration(ifGreaterThan value: Double) -> Double {
        if self.truncatingRemainder(dividingBy: 60) != 0 && self > value {
            return Double(Int(self / 60) + 1) * 60
        }
        return self
    }

    func ceilMeterDistance(ifGreaterThan value: Double) -> Double {
        if self.truncatingRemainder(dividingBy: 1000) != 0 && self > value {
            return Double(Int(self / 1000) + 1) * 1000
        }
        return self
    }
}

public extension Date {
    func format(with pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }

    func format(pattern: DKDatePattern) -> String {
        return format(with: pattern.rawValue)
    }
}

public extension String {
    static let nonBreakableSpace = "\u{00A0}"

    func doubleValue(locale: Locale? = nil) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let locale = locale {
            numberFormatter.locale = locale
        }
        return numberFormatter.number(from: self)?.doubleValue
    }

    func intValue() -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.number(from: self)?.intValue
    }

    func capitalizeFirstLetter() -> String {
        if !isEmpty {
            let first = prefix(1).uppercased()
            let other = suffix(count - 1)
            return first + other
        } else {
            return self
        }
    }
}
