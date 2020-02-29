//
//  DKDataFormatter.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public extension Double {
    
    //MARK : Distance methods
    func formatMeterDistance() -> String {
        let km = self.metersToKilometers(places: 1)
        return "\(km.stringWithoutZeroFraction) \(DKCommonLocalizable.unitKilometer.text())"
    }
    
    func metersToKilometers(places : Int) -> Double {
        let km = self / 1000.0
        let divisor = pow(10.0, Double(places))
        return (km * divisor).rounded() / divisor
    }
    
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    // MARK : Duration methods
    func formatSecondDuration() -> String {
        var nbMinute = 0
        var nbHour = 0
        var nbDay = 0
        if self > 60 {
            nbMinute = Int((self / 60).rounded(.down))
        }else {
            return "\(Int(self)) \(DKCommonLocalizable.unitSecond.text())"
        }
        if nbMinute > 59 {
            nbHour = nbMinute / 60
            nbMinute = nbMinute - (nbHour * 60)
            if nbHour > 23 {
                nbDay = nbHour / 24
                nbHour = nbHour - (24 * nbDay)
                return "\(nbDay)\(DKCommonLocalizable.unitDay.text()) \(nbHour)\(DKCommonLocalizable.unitHour.text())"
            }else{
                return "\(nbHour)\(DKCommonLocalizable.unitHour.text()) \(nbMinute)"
            }
        }else{
            return "\(nbMinute) \(DKCommonLocalizable.unitMinute.text())"
        }
    }
}


public extension Date {
    func format(with pattern : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }
    
    func format(pattern : DKDatePattern) -> String {
        return format(with: pattern.rawValue)
    }
}
