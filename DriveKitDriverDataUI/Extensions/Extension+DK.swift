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
    var duration: Int {
        guard let duration = self.tripStatistics?.duration else {
            return 0
        }
        return Int(duration)
    }

    var roundedDuration: Double {
        (Double(self.duration) / 60.0).rounded(.up) * 60.0
    }
    
    var tripStartDate: Date {
        return self.startDate ?? self.tripEndDate.addingTimeInterval(-1 * Double(duration)) as Date
    }
    
    var tripEndDate: Date {
        return self.endDate ?? Date()
    }
    
    var declaredTransportationModeInt: Int32? {
        return self.declaredTransportationMode?.transportationMode
    }

    var sortedCalls: [Call]? {
        if let calls = self.calls as? Set<Call> {
            let sortedCalls = calls.sorted(by: { call1, call2 -> Bool in
                call1.start < call2.start
            })
            return sortedCalls
        }
        return nil
    }
}

extension Array where Element: Trip {
    var totalDistance: Double {
        return map { ($0.tripStatistics?.distance ?? 0) }.reduce(0, +)
    }
    
    var totalDuration: Double {
        return map { Double($0.duration) }.reduce(0, +)
    }

    var totalRoundedDuration: Double {
        return map { $0.roundedDuration }.reduce(0, +)
    }
    
    func orderByDay(descOrder: Bool = true) -> [TripsByDate] {
        var tripsSorted: [TripsByDate] = []
        if !self.isEmpty {
            var dayTrips: [Trip] = []
            var currentDay = self[0].endDate
            if self.count > 1 {
                for i in 0..<self.count {
                    if NSCalendar.current.isDate(currentDay! as Date, inSameDayAs: self[i].endDate! as Date) {
                        dayTrips.append(self[i])
                    } else {
                        tripsSorted.append(newTripsByDate(date: currentDay!, trips: dayTrips, descOrder: descOrder))
                        currentDay = self[i].endDate
                        dayTrips = []
                        dayTrips.append(self[i])
                    }
                    if i == self.count - 1 {
                        tripsSorted.append(newTripsByDate(date: currentDay!, trips: dayTrips, descOrder: descOrder))
                    }
                }
            } else {
                dayTrips.append(self[0])
                tripsSorted.append(newTripsByDate(date: currentDay!, trips: dayTrips, descOrder: descOrder))
            }
        }
        return tripsSorted
    }

    private func newTripsByDate(date: Date, trips: [Trip], descOrder: Bool) -> TripsByDate {
        let sortedTrips = descOrder || trips.count < 2 ? trips : trips.reversed()
        let tripsByDate = TripsByDate(date: date, trips: sortedTrips)
        return tripsByDate
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
        case .speeding:
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
        case .speeding:
            return trip.speedingStatistics?.score ?? 0
        }
    }
}

extension DKStyle {
    static let driverDataText = DKStyles.normalText.withSizeDelta(-2)
}
