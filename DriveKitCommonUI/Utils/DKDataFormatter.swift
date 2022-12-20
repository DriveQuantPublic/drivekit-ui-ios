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

    func getKilometerDistanceFormat(appendingUnit appendUnit: Bool = true, minDistanceToRemoveFractions: Double = 100) -> [FormatType] {
        var formattingTypes: [FormatType] = []
        let formattedDistance: String
        if self < minDistanceToRemoveFractions {
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

    func formatKilometerDistance(appendingUnit appendUnit: Bool = true, minDistanceToRemoveFractions: Double = 100) -> String {
        getKilometerDistanceFormat(appendingUnit: appendUnit, minDistanceToRemoveFractions: minDistanceToRemoveFractions).toString()
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


    func getLiterFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(format(maximumFractionDigits: 1)),
            .separator(),
            .unit(DKCommonLocalizable.unitLiter.text())
        ]
        return formattingTypes
    }

    func formatLiter() -> String {
        return getLiterFormat().toString()
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


    func getScoreFormat() -> [FormatType] {
        let formattedScore = self.format(maximumFractionDigits: 1)
        let formattingTypes: [FormatType] = [
            .value(formattedScore),
            .separator(),
            .unit(DKCommonLocalizable.unitScore.text())
        ]
        return formattingTypes
    }

    func formatScore() -> String {
        getScoreFormat().toString()
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


    func getSecondDurationFormat(maxUnit: DurationUnit = .day) -> [FormatType] {
        let formattingTypes: [FormatType]
        var nbMinute = 0
        var nbHour = 0
        var nbDay = 0
        if maxUnit == .second || self <= 59 {
            formattingTypes = [
                .value(String(Int(self))),
                .separator(),
                .unit(DKCommonLocalizable.unitSecond.text())
            ]
        } else {
            nbMinute = Int((self / 60).rounded(.up))
            if nbMinute > 59 && maxUnit != .minute {
                nbHour = nbMinute / 60
                nbMinute = nbMinute - (nbHour * 60)
                if nbHour > 23 && maxUnit != .hour {
                    nbDay = nbHour / 24
                    nbHour = nbHour - (24 * nbDay)
                    if nbHour > 0 {
                        formattingTypes = [
                            .value(String(nbDay)),
                            .unit(DKCommonLocalizable.unitDay.text()),
                            .value(String(nbHour)),
                        ]
                    } else {
                        formattingTypes = [
                            .value(String(nbDay)),
                            .separator(),
                            .unit(DKCommonLocalizable.unitDay.text())
                        ]
                    }
                } else {
                    if nbMinute > 0 {
                        let minuteString = String(format: "%02d", nbMinute)
                        formattingTypes = [
                            .value(String(nbHour)),
                            .unit(DKCommonLocalizable.unitHour.text()),
                            .value(minuteString)
                        ]
                    } else {
                        formattingTypes = [
                            .value(String(nbHour)),
                            .separator(),
                            .unit(DKCommonLocalizable.unitHour.text())
                        ]
                    }
                }
            } else {
                let nbSecond = Int(self - 60.0 * Double(Int(self / 60)))
                if nbSecond > 0 {
                    let secondString = String(format: "%02d", nbSecond)
                    formattingTypes = [
                        .value(String(nbMinute - 1)),
                        .unit(DKCommonLocalizable.unitMinute.text()),
                        .value(secondString)
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

    func formatSecondDuration(maxUnit: DurationUnit = .day) -> String {
        return getSecondDurationFormat(maxUnit: maxUnit).toString()
    }


    func getCO2MassFormat(shouldUseNaturalUnit: Bool) -> [FormatType] {
        let formattingTypes: [FormatType]
        if self < 1 && shouldUseNaturalUnit {
            formattingTypes = [
                .value((self * 1000).format(maximumFractionDigits: 0)),
                .separator(),
                .unit(DKCommonLocalizable.unitGram.text())
            ]
        } else {
            formattingTypes = [
                .value(self.format(maximumFractionDigits: 1)),
                .separator(),
                .unit(DKCommonLocalizable.unitKilogram.text())
            ]
        }
        return formattingTypes
    }

    func formatCO2Mass(shouldUseNaturalUnit: Bool = true) -> String {
        return getCO2MassFormat(shouldUseNaturalUnit: shouldUseNaturalUnit).toString()
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

    func getSpeedMaintainDescription() -> String {
        let key: DKCommonLocalizable
        if self < Constants.Ecodriving.SpeedMaintain.goodLevelThreshold {
            key = .ecodrivingSpeedMaintainGood
        } else if self < Constants.Ecodriving.SpeedMaintain.weakLevelThreshold {
            key = .ecodrivingSpeedMaintainWeak
        } else {
            key = .ecodrivingSpeedMaintainBad
        }
        return key.text()
    }


    func getConsumptionFormat(_ type: DKConsumptionType = .fuel) -> [FormatType] {
        let unitText: String
        if type == .electric {
            unitText = DKCommonLocalizable.unitkWhPer100Km.text()
        } else {
            unitText = DKCommonLocalizable.unitLPer100Km.text()
        }
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 1)),
            .separator(),
            .unit(unitText)
        ]
        return formattingTypes
    }

    func formatConsumption(_ type: DKConsumptionType = .fuel) -> String {
        return getConsumptionFormat(type).toString()
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

    func getAccelerationDescription() -> String {
        let key: DKCommonLocalizable
        if self < Constants.Ecodriving.Acceleration.lowLevelThreshold {
            key = .ecodrivingAccelerationLow
        } else if self < Constants.Ecodriving.Acceleration.weakLevelThreshold {
            key =  .ecodrivingAccelerationWeak
        } else if self < Constants.Ecodriving.Acceleration.goodLevelThreshold {
            key =  .ecodrivingAccelerationGood
        } else if self < Constants.Ecodriving.Acceleration.strongLevelThreshold {
            key =  .ecodrivingAccelerationStrong
        } else {
            key =  .ecodrivingAccelerationHigh
        }
        return key.text()
    }

    func getDecelerationDescription() -> String {
        let key: DKCommonLocalizable
        if self < Constants.Ecodriving.Deceleration.lowLevelThreshold {
            key = .ecodrivingDecelerationLow
        } else if self < Constants.Ecodriving.Deceleration.weakLevelThreshold {
            key = .ecodrivingDecelerationWeak
        } else if self < Constants.Ecodriving.Deceleration.goodLevelThreshold {
            key = .ecodrivingDecelerationGood
        } else if self < Constants.Ecodriving.Deceleration.strongLevelThreshold {
            key = .ecodrivingDecelerationStrong
        } else {
            key = .ecodrivingDecelerationHigh
        }
        return key.text()
    }


    func getPercentageFormat() -> [FormatType] {
        let formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: 1)),
            .separator(),
            .unit("%")
        ]
        return formattingTypes
    }

    func formatPercentage() -> String {
        return getPercentageFormat().toString()
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

    func roundUp(step: Double) -> Double {
        return (self / step).rounded(.up) * step
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

    func isCompletelyEmpty() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}


public enum DurationUnit {
    case second, minute, hour, day
}

public extension Int {
    func roundUp(step: Double) -> Double {
        return (Double(self) / step).rounded(.up) * step
    }
}

public enum DKConsumptionType {
    case fuel, electric
}

private enum Constants {
    enum Ecodriving {
        enum SpeedMaintain {
            static let goodLevelThreshold: Double = 1.5
            static let weakLevelThreshold: Double = 3.5
        }

        enum Acceleration {
            static let lowLevelThreshold: Double = -4
            static let weakLevelThreshold: Double = -2
            static let goodLevelThreshold: Double = 1
            static let strongLevelThreshold: Double = 3
        }

        enum Deceleration {
            static let lowLevelThreshold: Double = -4
            static let weakLevelThreshold: Double = -2
            static let goodLevelThreshold: Double = 1
            static let strongLevelThreshold: Double = 3
        }
    }
}
