//
//  Extensions+DK.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 14/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

extension String {
    public func dkAchievementLocalized() -> String {
        return NSLocalizedString(self, tableName: "DriverAchievementLocalizables", bundle: Bundle.driverAchievementUIBundle ?? .main, value: "", comment: "")
    }
}

extension Double {
    func metersToKilometers(places : Int) -> Double {
        let km = self / 1000.0
        let divisor = pow(10.0, Double(places))
        return (km * divisor).rounded() / divisor
    }
    
    func secondToDayHourMinute() -> String {
        var nbMinute = 0
        var nbHour = 0
        var nbDay = 0
        if self > 60 {
            nbMinute = Int((self / 60).rounded(.down))
        }else if self > 0{
            nbMinute = 1
        }else {
            nbMinute = 0
        }
        if nbMinute > 59 {
            nbHour = nbMinute / 60
            nbMinute = nbMinute - (nbHour * 60)
            if nbHour > 23 {
                nbDay = nbHour / 24
                nbHour = nbHour - (24 * nbDay)
                return "\(nbDay)\("dk_unit_day".dkAchievementLocalized()) \(nbHour)\("dk_unit_hour".dkAchievementLocalized()) \(nbMinute)"
            }else{
                return "\(nbHour)\("dk_unit_hour".dkAchievementLocalized()) \(nbMinute)"
            }
        }else{
            return "\(nbMinute) \("dk_unit_minute".dkAchievementLocalized())"
        }
    }
    
}

extension Date {
    func format(with pattern : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }
}
