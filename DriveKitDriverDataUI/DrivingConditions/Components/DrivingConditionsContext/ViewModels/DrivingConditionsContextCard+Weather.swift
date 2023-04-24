//
//  DrivingConditionsContextCard+Weather.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

extension DrivingConditionsContextCard {
    func configureAsWeatherContext(
        with drivingConditions: DKDriverTimeline.DKDrivingConditions
    ) {
        let allWeather = [DKWeather.sun, .cloud, .fog, .rain, .snow, .hail]
        totalDistance = drivingConditions.distanceByWeatherType.reduce(into: 0.0, { totalDistanceSoFar, item in
            totalDistanceSoFar += item.value
        })
        
        let tempItems: [DKWeather: DrivingConditionsContextItem] = allWeather.enumerated().reduce(into: [:]) { contextItemsSoFar, weatherItem in
            if let distance = drivingConditions.distanceByWeatherType[weatherItem.element], distance > 0 {
                contextItemsSoFar[weatherItem.element] = .init(
                    title: weatherItem.element.itemTitle,
                    distance: distance,
                    totalDistance: totalDistance,
                    baseColor: DKContextCardColor.allCases[weatherItem.offset]
                )
            }
        }
        
        self.title = self.titleForItemWithMaxDistance(
            amongst: tempItems,
            titleForKey: { $0.mainTitle }
        )
        self.contextItems = allWeather.compactMap { tempItems[$0] }
        self.viewModelDidUpdate?()
    }
}

extension DKWeather {
    
    var mainTitle: String {
        switch self {
        case .sun:
            return "dk_driverdata_drivingconditions_main_sun".dkDriverDataLocalized()
        case .cloud:
            return "dk_driverdata_drivingconditions_main_cloud".dkDriverDataLocalized()
        case .fog:
            return "dk_driverdata_drivingconditions_main_fog".dkDriverDataLocalized()
        case .rain:
            return "dk_driverdata_drivingconditions_main_rain".dkDriverDataLocalized()
        case .snow:
            return "dk_driverdata_drivingconditions_main_snow".dkDriverDataLocalized()
        case .hail:
            return "dk_driverdata_drivingconditions_main_ice".dkDriverDataLocalized()
        case .unknown:
            assertionFailure("Unknown weather not managed yet")
            return ""
        }
    }
    
    var itemTitle: String {
        switch self {
        case .sun:
            return "dk_driverdata_drivingconditions_sun".dkDriverDataLocalized()
        case .cloud:
            return "dk_driverdata_drivingconditions_cloud".dkDriverDataLocalized()
        case .fog:
            return "dk_driverdata_drivingconditions_fog".dkDriverDataLocalized()
        case .rain:
            return "dk_driverdata_drivingconditions_rain".dkDriverDataLocalized()
        case .snow:
            return "dk_driverdata_drivingconditions_snow".dkDriverDataLocalized()
        case .hail:
            return "dk_driverdata_drivingconditions_ice".dkDriverDataLocalized()
        case .unknown:
            assertionFailure("Unknown weather not managed yet")
            return ""
        }
    }
}
