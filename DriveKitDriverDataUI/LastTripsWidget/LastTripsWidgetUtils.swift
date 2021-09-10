//
//  LastTripsWidgetUtils.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 20/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

struct LastTripsWidgetUtils {

    public static func getLastTrips(limit: Int) -> [Trip] {
        let transportationModes: [TransportationMode] = [.unknown, .car, .moto, .truck]
        let tripsQuery = getTripsQuery(forTransportationModes: transportationModes)
        let lastTrips = tripsQuery
            .orderBy(field: "endDate", ascending: false)
            .query()
            .limit(limit: limit)
            .execute()
        return lastTrips
    }

    private static func getTripsQuery(forTransportationModes transportationModes: [TransportationMode]) -> Query<Trip, Trip> {
        let transportationModesValues = transportationModes.map { $0.rawValue }
        let tripsQuery = DriveKitDriverData.shared.tripsQuery()
            .whereIn(field: "transportationMode", value: transportationModesValues)
        return tripsQuery
    }

}
