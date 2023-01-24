// swiftlint:disable all
//
//  Array+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public extension Array where Element: DKTripListItem {
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
            var dayTrips: [DKTripListItem] = []
            var currentDay = self[0].getEndDate()
            if self.count > 1 {
                for (index, trip) in self.enumerated() {
                    if Calendar.current.isDate(currentDay as Date, inSameDayAs: trip.getEndDate() as Date) {
                        dayTrips.append(trip)
                    } else {
                        tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
                        currentDay = trip.getEndDate()
                        dayTrips = []
                        dayTrips.append(trip)
                    }
                    if index == self.count - 1 {
                        tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
                    }
                }
            } else {
                dayTrips.append(self[0])
                tripsSorted.append(newTripsByDate(date: currentDay, trips: dayTrips, descOrder: descOrder))
            }
        }
        return tripsSorted.sorted(by: { tripsDay, tripsDay2 in
                return tripsDay.date >= tripsDay2.date
        })
    }

    private func newTripsByDate(date: Date, trips: [DKTripListItem], descOrder: Bool) -> DKTripsByDate {
        let sortedTrips = descOrder || trips.count < 2 ? trips : trips.reversed()
        let tripsByDate = DKTripsByDate(date: date, trips: sortedTrips)
        return tripsByDate
    }
}
