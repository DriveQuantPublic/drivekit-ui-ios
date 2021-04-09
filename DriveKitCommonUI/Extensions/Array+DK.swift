//
//  Array+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

extension Array where Element: DKTripsListItem {
    var totalDistance: Double {
        return map { ($0.getDistance() ?? 0) }.reduce(0, +)
    }
    
    var totalDuration: Double {
        return map { Double($0.getDuration()) }.reduce(0, +)
    }

    var totalRoundedDuration: Double {
        return map { $0.getDuration().roundUp(step: 60.0) }.reduce(0, +)
    }
    
    func orderByDay(descOrder: Bool = true) -> [DKTripsByDate] {
        var tripsSorted: [DKTripsByDate] = []
        if !self.isEmpty {
            var dayTrips: [DKTripsListItem] = []
            var currentDay = self[0].getEndDate()
            if self.count > 1 {
                for i in 0..<self.count {
                    if NSCalendar.current.isDate(currentDay as Date, inSameDayAs: self[i].getEndDate() as Date) {
                        dayTrips.append(self[i])
                    } else {
                        tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
                        currentDay = self[i].getEndDate()
                        dayTrips = []
                        dayTrips.append(self[i])
                    }
                    if i == self.count - 1 {
                        tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
                    }
                }
            } else {
                dayTrips.append(self[0])
                tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
            }
        }
        return tripsSorted
    }

    private func newTripsByDate(date: Date, trips: [DKTripsListItem], descOrder: Bool) -> DKTripsByDate {
        let sortedTrips = descOrder || trips.count < 2 ? trips : trips.reversed()
        let tripsByDate = DKTripsByDate(date: date, trips: sortedTrips)
        return tripsByDate
    }
}
