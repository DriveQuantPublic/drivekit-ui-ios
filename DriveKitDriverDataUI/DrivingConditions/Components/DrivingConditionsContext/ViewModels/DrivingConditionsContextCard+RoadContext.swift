//
//  DrivingConditionsContextCard+RoadContext.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension DrivingConditionsContextCard {
    func configureAsRoadContext(
        with distanceByRoadContext: [DKRoadContext: Double]
    ) {
        let allRoadContext = [DKRoadContext.heavyUrbanTraffic, .city, .suburban, .expressways]
        
        totalDistance = distanceByRoadContext.reduce(into: 0.0, { totalDistanceSoFar, item in
            totalDistanceSoFar += item.value
        })
        
        let tempItems: [DKRoadContext: DrivingConditionsContextItem] = allRoadContext.enumerated().reduce(into: [:]) { contextItemsSoFar, roadItem in
            if let distance = distanceByRoadContext[roadItem.element], distance > 0 {
                contextItemsSoFar[roadItem.element] = .init(
                    title: roadItem.element.itemTitle,
                    distance: distance,
                    totalDistance: totalDistance,
                    baseColor: DKContextCardColor.allCases[roadItem.offset]
                )
            }
        }
        self.title = title(for: tempItems)
        self.contextItems = allRoadContext.compactMap { tempItems[$0] }
        self.viewModelDidUpdate?()
    }

    private func title(for items: [DKRoadContext: DrivingConditionsContextItem]) -> String {
        var cityDistance: Double = 0
        var expressWayDistance: Double = 0
        var suburbanDistance: Double = 0
        for item in items {
            let distance = item.value.distance
            switch item.key {
            case .heavyUrbanTraffic,
                 .city:
                cityDistance += distance
            case .suburban:
                suburbanDistance += distance
            case .expressways:
                expressWayDistance += distance
            case .trafficJam:
                break
            }
        }
        if cityDistance >= suburbanDistance && cityDistance >= expressWayDistance {
            return "dk_driverdata_drivingconditions_main_city".dkDriverDataLocalized()
        } else if suburbanDistance >= expressWayDistance {
            return "dk_driverdata_drivingconditions_main_suburban".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_drivingconditions_main_expressways".dkDriverDataLocalized()
        }
    }
}

extension DKRoadContext {
    
    var itemTitle: String {
        switch self {
        case .suburban:
            return DKCommonLocalizable.contextExternal.text().firstCapitalized
        case .expressways:
            return DKCommonLocalizable.contextFastlane.text().firstCapitalized
        case .heavyUrbanTraffic:
            return DKCommonLocalizable.contextCityDense.text().firstCapitalized
        case .city:
            return DKCommonLocalizable.contextCity.text().firstCapitalized
        case .trafficJam:
            assertionFailure("Traffic jam not managed yet")
            return ""
        }
    }
}

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}