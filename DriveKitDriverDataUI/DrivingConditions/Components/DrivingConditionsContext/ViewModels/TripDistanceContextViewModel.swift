//
//  TripDistanceContextViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class TripDistanceContextViewModel {
    private var contextItems: [TripDistanceContextItem] = []
    var viewModelDidUpdate: (() -> Void)?

    func configure(with drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        var tempItems: [TripDistanceContextItem] = []
        if let distance = drivingConditions.distanceByCategory[.lessThan2Km], distance > 0 {
            tempItems.append(.lessThan2Km(distance: distance))
        }
        if let distance = drivingConditions.distanceByCategory[.from2To10Km], distance > 0 {
            tempItems.append(.from2To10Km(distance: distance))
        }
        if let distance = drivingConditions.distanceByCategory[.from10To50Km], distance > 0 {
            tempItems.append(.from10To50Km(distance: distance))
        }
        if let distance = drivingConditions.distanceByCategory[.from50To100Km], distance > 0 {
            tempItems.append(.from50To100Km(distance: distance))
        }
        if let distance = drivingConditions.distanceByCategory[.moreThan100Km], distance > 0 {
            tempItems.append(.moreThan100Km(distance: distance))
        }
        self.contextItems = tempItems
        self.viewModelDidUpdate?()
    }
}

extension TripDistanceContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return self.contextItems
    }
    
    var title: String {
        var maxDistance: Double = 0
        var mainItem: TripDistanceContextItem? = self.contextItems.first
        for item in self.contextItems where item.distance >= maxDistance {
            maxDistance = item.distance
            mainItem = item
        }
        guard let mainItem else {
            return ""
        }
        switch mainItem {
            case .lessThan2Km:
                return "dk_driverdata_drivingconditions_main_short_trips".dkDriverDataLocalized()
            case .from2To10Km:
                let minDistance: Int = 2
                let maxDistance: Int = 10
                return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from10To50Km:
                let minDistance: Int = 10
                let maxDistance: Int = 50
                return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from50To100Km:
                let minDistance: Int = 50
                let maxDistance: Int = 100
                return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .moreThan100Km:
                return "dk_driverdata_drivingconditions_main_long_trips".dkDriverDataLocalized()
        }
    }
    
    func getContextPercent(_ context: some DriveKitCommonUI.DKContextItem) -> Double {
        guard let contextItem = context as? TripDistanceContextItem else {
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

enum TripDistanceContextItem {
    case lessThan2Km(distance: Double)
    case from2To10Km(distance: Double)
    case from10To50Km(distance: Double)
    case from50To100Km(distance: Double)
    case moreThan100Km(distance: Double)

    var distance: Double {
        switch self {
            case .lessThan2Km(let distance):
                return distance
            case .from2To10Km(let distance):
                return distance
            case .from10To50Km(let distance):
                return distance
            case .from50To100Km(let distance):
                return distance
            case .moreThan100Km(let distance):
                return distance
        }
    }
}

extension TripDistanceContextItem: DKContextItem {
    var color: UIColor {
        switch self {
            case .lessThan2Km:
                return DKContextCardColor.level1.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .from2To10Km:
                return DKContextCardColor.level2.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .from10To50Km:
                return DKContextCardColor.level3.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .from50To100Km:
                return DKContextCardColor.level4.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
            case .moreThan100Km:
                return DKContextCardColor.level5.getColor().tinted(usingHueOf: DKUIColors.primaryColor.color)
        }
    }
    
    var title: String {
        switch self {
            case .lessThan2Km:
                return "dk_driverdata_drivingconditions_short_trips".dkDriverDataLocalized()
            case .from2To10Km:
                let minDistance: Int = 2
                let maxDistance: Int = 10
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from10To50Km:
                let minDistance: Int = 10
                let maxDistance: Int = 50
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from50To100Km:
                let minDistance: Int = 50
                let maxDistance: Int = 100
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .moreThan100Km:
                return "dk_driverdata_drivingconditions_long_trips".dkDriverDataLocalized()
        }
    }
    
    var subtitle: String? {
        switch self {
            case .lessThan2Km(let distance):
                return distance.formatKilometerDistance()
            case .from2To10Km(let distance):
                return distance.formatKilometerDistance()
            case .from10To50Km(let distance):
                return distance.formatKilometerDistance()
            case .from50To100Km(let distance):
                return distance.formatKilometerDistance()
            case .moreThan100Km(let distance):
                return distance.formatKilometerDistance()
        }
    }
}
