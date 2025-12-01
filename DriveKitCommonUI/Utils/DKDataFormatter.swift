// swiftlint:disable no_magic_numbers file_length
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
    public func toString() -> String {
        reduce(into: "") { (result, formatType) in
            result.append(formatType.string)
        }
    }
}

public extension Double {
    static let defaultMinDistanceToRemoveFractions = 100.0
    
    func getMeterDistanceInKmFormat(
        appendingUnit appendUnit: Bool = true,
        minDistanceToRemoveFractions: Double = defaultMinDistanceToRemoveFractions
    ) -> [FormatType] {
        return (self / 1_000.0).getKilometerDistanceFormat(
            appendingUnit: appendUnit,
            minDistanceToRemoveFractions: minDistanceToRemoveFractions
        )
    }

    func formatMeterDistanceInKm(
        appendingUnit appendUnit: Bool = true,
        minDistanceToRemoveFractions: Double = defaultMinDistanceToRemoveFractions
    ) -> String {
        return getMeterDistanceInKmFormat(
            appendingUnit: appendUnit,
            minDistanceToRemoveFractions: minDistanceToRemoveFractions).toString(
        )
    }

    func getMeterDistanceFormat(_ forcedUnitSystem: DKUnitSystem? = nil
) -> [FormatType] {
        let desiredUnitSystem: DKUnitSystem = forcedUnitSystem ?? DriveKitUI.shared.unitSystem

        let formattingTypes: [FormatType]
        if desiredUnitSystem == .metric {
            if self < 10 {
                formattingTypes = [
                    .value(format(maximumFractionDigits: 2)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitMeter.text())
                ]
            } else if self < 1_000 {
                formattingTypes = [
                    .value(format(maximumFractionDigits: 0)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitMeter.text())
                ]
            } else {
                formattingTypes = getMeterDistanceInKmFormat()
            }
        } else/* if desiredUnitSystem == .imperial*/ {
            formattingTypes = getMeterDistanceInKmFormat()
        }
        return formattingTypes
    }

    func formatMeterDistance(_ forcedUnitSystem: DKUnitSystem? = nil) -> String {
        return getMeterDistanceFormat(forcedUnitSystem).toString()
    }

    func getKilometerDistanceFormat(
        appendingUnit appendUnit: Bool = true,
        minDistanceToRemoveFractions: Double = defaultMinDistanceToRemoveFractions,
        forcedUnitSystem: DKUnitSystem? = nil
    ) -> [FormatType] {
        var formattingTypes: [FormatType] = []
        let desiredUnitSystem: DKUnitSystem = forcedUnitSystem ?? DriveKitUI.shared.unitSystem
        if desiredUnitSystem == .metric {
            let formattedDistance: String
            if self < minDistanceToRemoveFractions {
                formattedDistance = self.format(maximumFractionDigits: 1)
            } else {
                formattedDistance = Int(self.rounded()).formatWithThousandSeparator()
            }
            formattingTypes.append(.value(formattedDistance))
            if appendUnit {
                formattingTypes.append(.separator())
                formattingTypes.append(.unit(DKCommonLocalizable.unitKilometer.text()))
            }
        } else/* if desiredUnitSystem == .imperial*/ {
            let milesDistance = self.convertKmToMiles()
            let formattedDistance: String
            if milesDistance < minDistanceToRemoveFractions {
                formattedDistance = milesDistance.format(maximumFractionDigits: 1)
            } else {
                formattedDistance = Int(milesDistance.rounded()).formatWithThousandSeparator()
            }
            formattingTypes.append(.value(formattedDistance))
            if appendUnit {
                formattingTypes.append(.separator())
                formattingTypes.append(.unit(DKCommonLocalizable.unitMile.text()))
            }
        }
        return formattingTypes
    }

    func formatKilometerDistance(
        appendingUnit appendUnit: Bool = true,
        minDistanceToRemoveFractions: Double = defaultMinDistanceToRemoveFractions,
        forcedUnitSystem: DKUnitSystem? = nil
    ) -> String {
        getKilometerDistanceFormat(appendingUnit: appendUnit, minDistanceToRemoveFractions: minDistanceToRemoveFractions, forcedUnitSystem: forcedUnitSystem).toString()
    }

    func metersToKilometers(places: Int) -> Double {
        let km = self / 1_000.0
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
        let massInTon = self / 1_000.0
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

    func getVolumeFormat() -> [FormatType] {
        let volumeUnit: FormatType
        if DriveKitUI.shared.unitSystem == .metric {
            volumeUnit = .unit(DKCommonLocalizable.unitLiter.text())
        } else/* if DriveKitUI.shared.unitSystem == .imperial*/ {
            volumeUnit = .unit(DKCommonLocalizable.unitGallon.text())
        }
        return [
            .value(format(maximumFractionDigits: 1)),
            .separator(),
            volumeUnit
        ]
    }

    func formatVolume() -> String {
        return getVolumeFormat().toString()
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
        numberFormatter.usesGroupingSeparator = true
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

    func getSecondDurationColonsFormat() -> [FormatType] {
        var nbMinute = 0
        var nbHour = 0
        var nbSecond = 0
        
        nbMinute = Int(self) / 60
        if nbMinute > 59 {
            nbHour = nbMinute / 60
            nbMinute -= (nbHour * 60)
        }
        nbSecond = Int(self) - (nbMinute * 60) - (nbHour * 60 * 60)
            
        let hourString = String(format: "%02d", nbHour)
        let minuteString = String(format: "%02d", nbMinute)
        let secondString = String(format: "%02d", nbSecond)
        
        return [
            .value(hourString),
            .unit(":"),
            .value(minuteString),
            .unit(":"),
            .value(secondString)
        ]
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
                nbMinute -= (nbHour * 60)
                if nbHour > 23 && maxUnit != .hour {
                    nbDay = nbHour / 24
                    nbHour -= (24 * nbDay)
                    if nbHour > 0 {
                        formattingTypes = [
                            .value(String(nbDay)),
                            .unit(DKCommonLocalizable.unitDay.text()),
                            .value(String(nbHour))
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
    
    func formatSecondDurationWithColons() -> String {
        return getSecondDurationColonsFormat().toString()
    }

    func getCO2MassFormat(shouldUseNaturalUnit: Bool) -> [FormatType] {
        let formattingTypes: [FormatType]
        if self < 1 && shouldUseNaturalUnit {
            formattingTypes = [
                .value((self * 1_000).format(maximumFractionDigits: 0)),
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
        if DriveKitUI.shared.unitSystem == .metric {
            return [
                .value(self.format(maximumFractionDigits: 0)),
                .separator(),
                .unit(DKCommonLocalizable.unitKmPerHour.text())
            ]
        } else/* if DriveKitUI.shared.unitSystem == .imperial*/ {
            let mphSpeed = Measurement(value: self, unit: UnitSpeed.kilometersPerHour).converted(to: .milesPerHour).value
            return [
                .value(mphSpeed.format(maximumFractionDigits: 0)),
                .separator(),
                .unit(DKCommonLocalizable.unitMPH.text())
            ]
        }
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
        if type == .electric {
            if DriveKitUI.shared.unitSystem == .metric {
                return [
                    .value(self.format(maximumFractionDigits: 1)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitkWhPer100Km.text())
                ]
            } else/* if DriveKitUI.shared.unitSystem == .imperial*/ {
                return [
                    .value(self.convertKWhPer100kmToMiPerkWh().format(maximumFractionDigits: 1)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitMilePerKWh.text())
                ]
            }
        } else {
            if DriveKitUI.shared.unitSystem == .metric {
                return [
                    .value(self.format(maximumFractionDigits: 1)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitLPer100Km.text())
                ]
            } else/* if DriveKitUI.shared.unitSystem == .imperial*/ {
                let fuelEfficiency = Measurement(value: self, unit: UnitFuelEfficiency.litersPer100Kilometers)
                let mpgfuelEfficiency = self != 0 ? fuelEfficiency.converted(to: .milesPerImperialGallon).value : 0
                return [
                    .value(mpgfuelEfficiency.format(maximumFractionDigits: 1)),
                    .separator(),
                    .unit(DKCommonLocalizable.unitMPG.text())
                ]
            }
        }
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
            key = .ecodrivingAccelerationWeak
        } else if self < Constants.Ecodriving.Acceleration.goodLevelThreshold {
            key = .ecodrivingAccelerationGood
        } else if self < Constants.Ecodriving.Acceleration.strongLevelThreshold {
            key = .ecodrivingAccelerationStrong
        } else {
            key = .ecodrivingAccelerationHigh
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

    func getPercentageFormat(
        appendingUnit appendUnit: Bool = true,
        fractionDigits: Int = 1
    ) -> [FormatType] {
        var formattingTypes: [FormatType] = [
            .value(self.format(maximumFractionDigits: fractionDigits))
        ]
        if appendUnit {
            formattingTypes.append(.unit("%"))
        }
        return formattingTypes
    }

    func formatPercentage(
        appendingUnit appendUnit: Bool = true,
        fractionDigits: Int = 1
    ) -> String {
        return getPercentageFormat(
            appendingUnit: appendUnit,
            fractionDigits: 0
        ).toString()
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
        if self.truncatingRemainder(dividingBy: 1_000) != 0 && self > value {
            return Double(Int(self / 1_000) + 1) * 1_000
        }
        return self
    }

    func roundUp(step: Double) -> Double {
        return (self / step).rounded(.up) * step
    }

    func roundNearest(step: Double) -> Double {
        return (self / step).rounded(.toNearestOrAwayFromZero) * step
    }

    func convertKmToMiles() -> Double {
        let distance = Measurement(value: self, unit: UnitLength.kilometers)
        return distance.converted(to: .miles).value
    }

    func convertKWhPer100kmToMiPerkWh() -> Double {
        if self == 0 {
            return 0
        }
        let distanceFactor = Measurement(value: 1, unit: UnitLength.kilometers).converted(to: .miles).value
        return (100 / self) * distanceFactor
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
    
    func formatWithThousandSeparator() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
        return formattedNumber
    }

    func convertKmToMiles() -> Int {
        return Int(Measurement(value: Double(self), unit: UnitLength.kilometers).converted(to: .miles).value.rounded())
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
