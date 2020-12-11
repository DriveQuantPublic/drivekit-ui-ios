//
//  Extension + DK.swift
//  
//
//  Created by Meryl Barantal on 21/10/2019.
//

import UIKit
import DriveKitDriverDataModule
import DriveKitDBTripAccessModule
import CoreLocation
import DriveKitCommonUI

extension Trip {    
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
    
    var declaredTransportationModeInt: Int32? {
        return self.declaredTransportationMode?.transportationMode
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
    func adviceImage() -> UIImage?{
        if self.theme == "SAFETY" {
            return UIImage(named: "dk_safety_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        }else if self.theme == "ECODRIVING" {
            return UIImage(named: "dk_eco_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        }else{
            return nil
        }
    }
}

extension ScoreType {
    func isScored(trip: Trip) -> Bool {
        switch self {
        case .ecoDriving:
            return rawValue(trip: trip) <= 10 ? true : false
        case .safety:
            return rawValue(trip: trip) <= 10 ? true : false
        case .distraction:
            return rawValue(trip: trip) <= 10 ? true : false
        }
    }
    
    func rawValue(trip: Trip) -> Double {
        switch self {
        case .ecoDriving:
            return trip.ecoDriving?.score ?? 0
        case .safety:
            return  trip.safety?.safetyScore ?? 0
        case .distraction:
            return trip.driverDistraction?.score ?? 0
            
        }
    }
}
