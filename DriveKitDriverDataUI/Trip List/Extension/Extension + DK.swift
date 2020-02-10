//
//  Extension + DK.swift
//  
//
//  Created by Meryl Barantal on 21/10/2019.
//

import UIKit
import DriveKitDriverData
import DriveKitDBTripAccess
import CoreLocation

extension Trip {
    var formattedDuration : String {
        if let tripDuration = self.tripStatistics?.duration {
            return Double(tripDuration).formattedDuration
        } else {
            return "0 \("dk_unit_minute".dkLocalized())"
        }
    }
    
    var duration : Int {
        guard let duration = self.tripStatistics?.duration else {
            return 0
        }
        return Int(duration)
    }
    
    var tripStartDate : Date {
        return self.startDate ?? self.tripEndDate.addingTimeInterval(-1 * Double(duration)) as Date
    }
    
    var tripEndDate: Date {
        return self.endDate ?? Date()
    }
}

extension Array where Element: Trip {
    var totalDistance: Double {
        return map { ($0.tripStatistics?.distance ?? 0) }.reduce(0, +)
    }
    
    var totalDuration: Double {
        return map { Double($0.tripStatistics?.duration ?? 0) }.reduce(0, +)
    }
    
    func orderByDay(descOrder: Bool = true) -> [TripsByDate] {
        var tripsSorted : [TripsByDate] = []
        if self.count > 0 {
            var dayTrips : [Trip] = []
            var currentDay = self[0].endDate
            if self.count > 1 {
                for i in 0...self.count-1{
                    if NSCalendar.current.isDate(currentDay! as Date, inSameDayAs:self[i].endDate! as Date){
                        dayTrips.append(self[i])
                        if i == self.count-1 {
                            let tripsByDate = TripsByDate(date: currentDay!, trips: dayTrips)
                            tripsSorted.append(tripsByDate)
                        }
                    } else {
                        if !descOrder {
                            dayTrips = dayTrips.reversed()
                        }
                        let tripsByDate = TripsByDate(date: currentDay!, trips: dayTrips)
                        tripsSorted.append(tripsByDate)
                        currentDay = self[i].endDate
                        dayTrips = []
                        dayTrips.append(self[i])
                    }
                }
            } else {
                dayTrips.append(self[0])
                let tripsByDate = TripsByDate(date: currentDay!, trips: dayTrips)
                tripsSorted.append(tripsByDate)
            }
        }
        return tripsSorted
    }
}

extension Date {
    func dateToDay() -> String {
        return DateFormatter.day.string(from: self).capitalized
    }
    
    func dateToTime() -> String {
        return DateFormatter.time.string(from: self)
    }
}

extension DateFormatter {
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH'\("dk_unit_hour".dkLocalized())'mm"
        return formatter
    }()
}




extension String {
    public func dkLocalized() -> String {
        return NSLocalizedString(self, tableName: "DriverDataLocalizables", bundle: Bundle.driverDataUIBundle ?? .main, value: self, comment: "")
    }
}


extension Double {
    var formattedDuration : String {
        let minPattern = "dk_unit_minute".dkLocalized()
        let hourPattern = "dk_unit_hour".dkLocalized()
        if self < 60  {
            let secString = "1\(minPattern)"
            return secString
        }
        var minutes = self / 60
        if (Int(self) % 60 > 0) {
            minutes += 1
        }
        if minutes > 60 {
            let hours = minutes / 60
            let remainingMinutes = Int(minutes) % 60
            let minutesString = remainingMinutes < 10 ? "0\(remainingMinutes)" : "\(remainingMinutes)"
            return "\(Int(hours))\(hourPattern)\(minutesString)"
        }else{
            let minutesString = String(format: "%.0f \(minPattern)", minutes)
            return minutesString
        }
        
        
    }
    
    func asDistanceInKm() -> Double {
        return self / 1000
    }
    
    var plainFormattedDistance: String {
        return String(format: "%.1f", self.asDistanceInKm())
    }
    
    var formattedDistance: String {
        return plainFormattedDistance + " " + "dk_unit_km".dkLocalized()
    }
    
    var formattedDistanceNoDigits: String {
        return String(format: "%.0f", self)
    }
    
    var formattedScore: String {
        return String(format: "%.1f", self)
    }
    
    var asDate : Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Route {
        
    var startLocation: CLLocationCoordinate2D {
        return coordinate(at: 0)
    }
    
    var endLocation: CLLocationCoordinate2D {
        return coordinate(at: lastIndex)
    }
    
    var lastIndex: Int {
        return numberOfCoordinates - 1
    }
    
    var numberOfCoordinates: Int {
        return longitude?.count ?? 0
    }
    
    func coordinate(at index: Int) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude![index], longitude![index])
    }
}

extension TripAdvice {
    func getTripInfo() -> TripInfo?{
        if theme == "SAFETY"{
            return .safety
        }else if theme == "ECODRIVING" {
            return .ecoDriving
        }else{
            return nil
        }
    }
}
