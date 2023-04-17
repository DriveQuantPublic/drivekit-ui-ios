//
//  ConditionsRoadContextViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class ConditionsRoadContextViewModel {
    private var contextItems: [ConditionsRoadContextItem] = []
    var viewModelDidUpdate: (() -> Void)?

    func configure(with distanceByRoadContext: [DKRoadContext: Double]) {
        var tempItems: [ConditionsRoadContextItem] = []
        if let distance = distanceByRoadContext[.heavyUrbanTraffic], distance > 0 {
            tempItems.append(.heavyUrbanTraffic(distance: distance))
        }
        if let distance = distanceByRoadContext[.city], distance > 0 {
            tempItems.append(.city(distance: distance))
        }
        if let distance = distanceByRoadContext[.suburban], distance > 0 {
            tempItems.append(.suburban(distance: distance))
        }
        if let distance = distanceByRoadContext[.expressways], distance > 0 {
            tempItems.append(.expressways(distance: distance))
        }
        self.contextItems = tempItems
        self.viewModelDidUpdate?()
    }
}

extension ConditionsRoadContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        var cityDistance: Double = 0
        var expressWayDistance: Double = 0
        var suburbanDistance: Double = 0
        for item in contextItems {
            switch item {
                case .heavyUrbanTraffic(let distance):
                    cityDistance += distance
                case .city(let distance):
                    cityDistance += distance
                case .suburban(let distance):
                    suburbanDistance += distance
                case .expressways(let distance):
                    expressWayDistance += distance
            }
        }
        if cityDistance >= suburbanDistance && cityDistance >= expressWayDistance {
            return "dk_driverdata_drivingconditions_main_city".dkDriverDataLocalized()
        } else if suburbanDistance >= expressWayDistance {
            return "dk_driverdata_drivingconditions_main_suburban".dkDriverDataLocalized()
        } else {
            return "dk_driverdata_drivingconditions_main_expressways".dkDriverDataLocalized()
        }
//        var maxDistance: Double = 0
//        var mainItem: ConditionsRoadContextItem? = self.contextItems.first
//        for item in self.contextItems where item.distance >= maxDistance {
//            maxDistance = item.distance
//            mainItem = item
//        }
//        guard let mainItem else {
//            return ""
//        }
//        switch mainItem {
//            case .sun:
//                return "dk_driverdata_drivingconditions_main_sun".dkDriverDataLocalized()
//            case .cloud:
//                return "dk_driverdata_drivingconditions_main_cloud".dkDriverDataLocalized()
//            case .fog:
//                return "dk_driverdata_drivingconditions_main_fog".dkDriverDataLocalized()
//            case .rain:
//                return "dk_driverdata_drivingconditions_main_rain".dkDriverDataLocalized()
//            case .snow:
//                return "dk_driverdata_drivingconditions_main_snow".dkDriverDataLocalized()
//            case .hail:
//                return "dk_driverdata_drivingconditions_main_ice".dkDriverDataLocalized()
//        }
        return ""
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? ConditionsRoadContextItem else {
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

enum ConditionsRoadContextItem {
    case heavyUrbanTraffic(distance: Double)
    case city(distance: Double)
    case suburban(distance: Double)
    case expressways(distance: Double)

    var distance: Double {
        switch self {
            case .heavyUrbanTraffic(let distance):
                return distance
            case .city(let distance):
                return distance
            case .suburban(let distance):
                return distance
            case .expressways(let distance):
                return distance
        }
    }
}

extension ConditionsRoadContextItem: DKContextItem {
    var color: UIColor {
        switch self {
            case .heavyUrbanTraffic:
                return DKContextCardColor.level1.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .city:
                return DKContextCardColor.level2.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .suburban:
                return DKContextCardColor.level3.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .expressways:
                return DKContextCardColor.level4.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
        }
    }
    
    var title: String {
        switch self {
            case .heavyUrbanTraffic:
                return "dk_driverdata_drivingconditions_sun".dkDriverDataLocalized()
            case .city:
                return "dk_driverdata_drivingconditions_cloud".dkDriverDataLocalized()
            case .suburban:
                return "dk_driverdata_drivingconditions_fog".dkDriverDataLocalized()
            case .expressways:
                return "dk_driverdata_drivingconditions_rain".dkDriverDataLocalized()
        }
    }
    
    var subtitle: String? {
        switch self {
            case .heavyUrbanTraffic(let distance):
                return distance.formatKilometerDistance()
            case .city(let distance):
                return distance.formatKilometerDistance()
            case .suburban(let distance):
                return distance.formatKilometerDistance()
            case .expressways(let distance):
                return distance.formatKilometerDistance()
        }
    }
}
