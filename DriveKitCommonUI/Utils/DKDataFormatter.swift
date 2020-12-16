//
//  DKDataFormatter.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public extension Double {

    func formatMeterDistanceInKm() -> String {
        return (self / 1000.0).formatKilometerDistance()
    }

    func formatMeterDistance() -> String {
        if self < 10 {
            return "\(format(maximumFractionDigits: 2)) \(DKCommonLocalizable.unitMeter.text())"
        } else if self < 1000 {
            return "\(format(maximumFractionDigits: 0)) \(DKCommonLocalizable.unitMeter.text())"
        } else {
            return formatMeterDistanceInKm()
        }
    }

    func formatKilometerDistance() -> String {
        if self < 100 {
            return "\(self.format(maximumFractionDigits: 1)) \(DKCommonLocalizable.unitKilometer.text())"
        } else {
            return "\(Int(ceil(self))) \(DKCommonLocalizable.unitKilometer.text())"
        }
    }

    func metersToKilometers(places: Int) -> Double {
        let km = self / 1000.0
        return km.round(places: places)
    }

    func formatMass() -> String {
        let formattedMass = format(maximumFractionDigits: 0)
        return "\(formattedMass) \(DKCommonLocalizable.unitKilogram.text())"
    }

    func formatMassInTon() -> String {
        let massInTon = self / 1000.0
        let formattedMass = massInTon.format(maximumFractionDigits: 1)
        return "\(formattedMass) \(DKCommonLocalizable.unitTon.text())"
    }

    func formatPower() -> String {
        let formattedPower = self.format(maximumFractionDigits: 0)
        return "\(formattedPower) \(DKCommonLocalizable.unitPower.text())"
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

    func formatSecondDuration() -> String {
        var nbMinute = 0
        var nbHour = 0
        var nbDay = 0
        if self > 59 {
            nbMinute = Int((self / 60).rounded(.up))
        } else {
            return "\(Int(self)) \(DKCommonLocalizable.unitSecond.text())"
        }
        if nbMinute > 59 {
            nbHour = nbMinute / 60
            nbMinute = nbMinute - (nbHour * 60)
            if nbHour > 23 {
                nbDay = nbHour / 24
                nbHour = nbHour - (24 * nbDay)
                return "\(nbDay)\(DKCommonLocalizable.unitDay.text()) \(nbHour)\(DKCommonLocalizable.unitHour.text())"
            } else {
                let minuteString = String(format: "%02d", nbMinute)
                return "\(nbHour)\(DKCommonLocalizable.unitHour.text())\(minuteString)"
            }
        } else {
            return "\(nbMinute) \(DKCommonLocalizable.unitMinute.text())"
        }
    }

    func formatCO2Mass() -> String {
        if self < 1 {
            return "\((self * 1000).format(maximumFractionDigits: 0)) \(DKCommonLocalizable.unitGram.text())"
        } else {
            return "\(self.format(maximumFractionDigits: 2)) \(DKCommonLocalizable.unitKilogram.text())"
        }
    }

    func formatCO2Emission() -> String {
        return "\(self.format(maximumFractionDigits: 0)) \(DKCommonLocalizable.unitGperKM.text())"
    }

    func formatSpeedMean() -> String {
        return "\(self.format(maximumFractionDigits: 0)) \(DKCommonLocalizable.unitKmPerHour.text())"
    }

    func formatConsumption() -> String {
        return "\(self.format(maximumFractionDigits: 1)) \(DKCommonLocalizable.unitLPer100Km.text())"
    }

    func formatAcceleration() -> String {
        return "\(self.format(maximumFractionDigits: 2)) \(DKCommonLocalizable.unitAcceleration.text())"
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
    func doubleValue() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
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
