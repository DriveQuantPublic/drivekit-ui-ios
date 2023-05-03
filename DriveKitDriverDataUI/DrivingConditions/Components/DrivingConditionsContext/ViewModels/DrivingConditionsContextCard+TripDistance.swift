//
//  DrivingConditionsContextCard+TripDistance.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 14/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import UIKit

extension DrivingConditionsContextCard {
    func configureAsTripDistanceContext(
        with drivingConditions: DKDriverTimeline.DKDrivingConditions
    ) {
        let allCategories = [DKDrivingCategory.lessThan2Km, .from2To10Km, .from10To50Km, .from50To100Km, .moreThan100Km]
        
        totalItemsValue = drivingConditions.tripCountByCategory.reduce(into: 0.0, { totalTripCountSoFar, item in
            totalTripCountSoFar += Double(item.value)
        })
        
        let tempItems: [DKDrivingCategory: DrivingConditionsContextItem] = allCategories.enumerated().reduce(into: [:]) { contextItemsSoFar, categoryItem in
            if let tripCount = drivingConditions.tripCountByCategory[categoryItem.element], tripCount > 0 {
                contextItemsSoFar[categoryItem.element] = .init(
                    title: categoryItem.element.itemTitle,
                    itemValue: Double(tripCount),
                    totalItemsValue: totalItemsValue,
                    baseColor: DKContextCardColor.allCases[categoryItem.offset],
                    unitKind: .trip
                )
            }
        }
        
        self.title = self.titleForItemWithMaxValue(
            amongst: tempItems,
            titleForKey: { $0.mainTitle }
        )
        self.contextItems = allCategories.compactMap { tempItems[$0] }
        self.viewModelDidUpdate?()
    }
}

extension DKDrivingCategory {
    // swiftlint:disable no_magic_numbers
    var minDistance: Int {
        switch self {
        case .lessThan2Km:
            return 0
        case .from2To10Km:
            return 2
        case .from10To50Km:
            return 10
        case .from50To100Km:
            return 50
        case .moreThan100Km:
            return 100
        @unknown default:
            assertionFailure("Driving category \(self) not managed yet")
            return 0
        }
    }
    var maxDistance: Int {
        switch self {
        case .lessThan2Km:
            return 2
        case .from2To10Km:
            return 10
        case .from10To50Km:
            return 50
        case .from50To100Km:
            return 100
        case .moreThan100Km:
            return 1_000_000
        @unknown default:
            assertionFailure("Driving category \(self) not managed yet")
            return 1
        }
    }
    // swiftlint:enable no_magic_numbers
    
    var itemTitle: String {
        switch self {
            case .lessThan2Km:
                return "dk_driverdata_drivingconditions_short_trips".dkDriverDataLocalized()
            case .from2To10Km:
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from10To50Km:
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .from50To100Km:
                return String(format: "dk_driverdata_drivingconditions_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
            case .moreThan100Km:
                return "dk_driverdata_drivingconditions_long_trips".dkDriverDataLocalized()
        @unknown default:
            assertionFailure("Driving category \(self) not managed yet")
            return ""
        }
    }
    
    var mainTitle: String {
        switch self {
        case .lessThan2Km:
            return "dk_driverdata_drivingconditions_main_short_trips".dkDriverDataLocalized()
        case .from2To10Km:
            return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
        case .from10To50Km:
            return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
        case .from50To100Km:
            return String(format: "dk_driverdata_drivingconditions_main_interval_distance".dkDriverDataLocalized(), minDistance, maxDistance)
        case .moreThan100Km:
            return "dk_driverdata_drivingconditions_main_long_trips".dkDriverDataLocalized()
        @unknown default:
            assertionFailure("Driving category \(self) not managed yet")
            return ""
        }
    }
}
