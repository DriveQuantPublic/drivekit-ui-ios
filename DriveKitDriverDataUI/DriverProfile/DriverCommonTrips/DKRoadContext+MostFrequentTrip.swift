//
//  DKRoadContext+MostFrequentTrip.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 04/07/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

extension DKRoadContext {
    var mostFrequentTripContext: String {
        switch self {
        case .trafficJam:
            return "dk_driverdata_usual_trip_card_context_traffic_jam"
                .dkDriverDataLocalized()
        case .heavyUrbanTraffic:
            return "dk_driverdata_usual_trip_card_context_heavy_urban"
                .dkDriverDataLocalized()
        case .city:
            return "dk_driverdata_usual_trip_card_context_city"
                .dkDriverDataLocalized()
        case .suburban:
            return "dk_driverdata_usual_trip_card_context_suburban"
                .dkDriverDataLocalized()
        case .expressways:
            return "dk_driverdata_usual_trip_card_context_expressways"
                .dkDriverDataLocalized()
        }
    }
}
