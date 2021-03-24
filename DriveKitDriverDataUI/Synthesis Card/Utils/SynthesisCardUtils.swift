//
//  SynthesisCardUtils.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 28/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

public struct SynthesisCardUtils {

    public static func getLastTrip(withTransportationModes transportationModes: [TransportationMode] = [.unknown, .car, .moto, .truck]) -> Trip? {
        let tripsQuery = getTripsQuery(forTransportationModes: transportationModes)
        let lastTrip = tripsQuery
            .orderBy(field: "endDate", ascending: false)
            .query()
            .limit(limit: 1)
            .execute()
        return lastTrip.first
    }

    public static func getLastTrips(withTransportationModes transportationModes: [TransportationMode] = [.unknown, .car, .moto, .truck]) -> [Trip] {
        if let lastTrip = getLastTrip(withTransportationModes: transportationModes), let lastDate = lastTrip.endDate {
            let oneWeekBeforeDate = lastDate.addingTimeInterval(-7 * 24 * 3600) // 7 days.
            let tripsQuery = getTripsQuery(forTransportationModes: transportationModes)
            let lastTrips = tripsQuery
                .and()
                .whereGreaterThanOrEqual(field: "endDate", value: oneWeekBeforeDate)
                .orderBy(field: "endDate", ascending: false)
                .query()
                .execute()
            return lastTrips
        } else {
            return []
        }
    }

    private static func getTripsQuery(forTransportationModes transportationModes: [TransportationMode]) -> Query<Trip, Trip> {
        let transportationModesValues = transportationModes.map { $0.rawValue }
        let tripsQuery = DriveKitDriverData.shared.tripsQuery()
            .whereIn(field: "transportationMode", value: transportationModesValues)
        return tripsQuery
    }
}
