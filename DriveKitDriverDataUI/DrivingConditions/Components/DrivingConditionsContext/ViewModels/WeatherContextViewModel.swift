//
//  WeatherContextViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class WeatherContextViewModel {
    private var contextItems: [WeatherContextItem] = []
    var viewModelDidUpdate: (() -> Void)?

    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        var tempItems: [WeatherContextItem] = []
        if let distance = drivingConditions.distanceByWeatherType[.sun], distance > 0 {
            tempItems.append(.sun(distance: distance))
        }
        if let distance = drivingConditions.distanceByWeatherType[.cloud], distance > 0 {
            tempItems.append(.cloud(distance: distance))
        }
        if let distance = drivingConditions.distanceByWeatherType[.fog], distance > 0 {
            tempItems.append(.fog(distance: distance))
        }
        if let distance = drivingConditions.distanceByWeatherType[.rain], distance > 0 {
            tempItems.append(.rain(distance: distance))
        }
        if let distance = drivingConditions.distanceByWeatherType[.snow], distance > 0 {
            tempItems.append(.snow(distance: distance))
        }
        if let distance = drivingConditions.distanceByWeatherType[.hail], distance > 0 {
            tempItems.append(.hail(distance: distance))
        }
        self.contextItems = tempItems
        self.viewModelDidUpdate?()
    }
}

extension WeatherContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        var maxDistance: Double = 0
        var mainItem: WeatherContextItem? = self.contextItems.first
        for item in self.contextItems where item.distance >= maxDistance {
            maxDistance = item.distance
            mainItem = item
        }
        guard let mainItem else {
            return ""
        }
        switch mainItem {
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
        }
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? WeatherContextItem else {
            return 0
        }
        let totalDistance = self.contextItems.reduce(0) {
            $0 + $1.distance
        }
        return contextItem.distance / totalDistance
    }

    func contextCard(_ updateCompletionHandler: (() -> Void)?) {
        self.viewModelDidUpdate = updateCompletionHandler
    }
}

enum WeatherContextItem {
    case sun(distance: Double)
    case cloud(distance: Double)
    case fog(distance: Double)
    case rain(distance: Double)
    case snow(distance: Double)
    case hail(distance: Double)

    var distance: Double {
        switch self {
            case .sun(let distance):
                return distance
            case .cloud(let distance):
                return distance
            case .fog(let distance):
                return distance
            case .rain(let distance):
                return distance
            case .snow(let distance):
                return distance
            case .hail(let distance):
                return distance
        }
    }
}

extension WeatherContextItem: DKContextItem {
    var color: UIColor {
        switch self {
            case .sun:
                return DKContextCardColor.level1.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .cloud:
                return DKContextCardColor.level2.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .fog:
                return DKContextCardColor.level3.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .rain:
                return DKContextCardColor.level4.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .snow:
                return DKContextCardColor.level5.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .hail:
                return DKContextCardColor.level6.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
        }
    }
    
    var title: String {
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
        }
    }
    
    var subtitle: String? {
        switch self {
            case .sun(let distance):
                return distance.formatKilometerDistance()
            case .cloud(let distance):
                return distance.formatKilometerDistance()
            case .fog(let distance):
                return distance.formatKilometerDistance()
            case .rain(let distance):
                return distance.formatKilometerDistance()
            case .snow(let distance):
                return distance.formatKilometerDistance()
            case .hail(let distance):
                return distance.formatKilometerDistance()
        }
    }
}
