//
//  RoadContextViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class RoadContextViewModel {
    private let distanceByContext: [DKRoadContext: Double]
    private let distance: Double
    private static let backgroundColor = UIColor(hex: 0xFAFAFA)
    private static let urbainDenseColor = UIColor(hex: 0x036A82)
    private static let subUrbainColor = UIColor(hex: 0x699DAD)
    private static let urbainFluidColor = UIColor(hex: 0x3B8497)
    private static let highwayColor = UIColor(hex: 0x8FB7C2)

    init(distanceByContext: [DKRoadContext: Double], distance: Double) {
        self.distanceByContext = distanceByContext
        self.distance = distance
    }

    lazy var itemsToDraw: [(context: DKRoadContext, percent: Double)] = {
        var result: [(context: DKRoadContext, percent: Double)] = []
        let heavyUrbanTrafficPercent = getHeavyUrbanTrafficPercent()
        if heavyUrbanTrafficPercent > 0 {
            result.append((.heavyUrbanTraffic, heavyUrbanTrafficPercent))
        }
        let cityPercent = getCityPercent()
        if cityPercent > 0 {
            result.append((.city, cityPercent))
        }
        let suburbanPercent = getSuburbanPercent()
        if suburbanPercent > 0 {
            result.append((.suburban, suburbanPercent))
        }
        let expresswaysPercent = getExpresswaysPercent()
        if expresswaysPercent > 0 {
            result.append((.expressways, expresswaysPercent))
        }
       return result
    }()

    func getTitle() -> String {
        return "dk_road_context_title".dkDriverDataTimelineLocalized() + " (\(distance.formatMeterDistanceInKm())"
    }
    
    private lazy var totalCalculatedDistance: Double = {
        var totalDist: Double = 0
        for (context, dist) in distanceByContext {
            if dist > 0 && context != .trafficJam {
                totalDist = totalDist + dist
            }
        }
        return totalDist
    }()
    
    func getActiveContextNumber() -> Int {
        var total: Int = 0
        for (context, dist) in distanceByContext {
            if dist > 0 && context != .trafficJam {
                total = total + 1
            }
        }
        return total
    }
    
    func getHeavyUrbanTrafficPercent() -> Double {
        guard let distance = distanceByContext[.heavyUrbanTraffic] else {
            return 0
        }
        return distance/totalCalculatedDistance
    }
    
    func getCityPercent() -> Double {
        guard let distance = distanceByContext[.city] else {
            return 0
        }
        return distance/totalCalculatedDistance
    }
    
    func getExpresswaysPercent() -> Double {
        guard let distance = distanceByContext[.expressways] else {
            return 0
        }
        return distance/totalCalculatedDistance
    }
    
    func getSuburbanPercent() -> Double {
        guard let distance = distanceByContext[.suburban] else {
            return 0
        }
        return distance/totalCalculatedDistance
    }

    static func getContextColor(_ context: DKRoadContext) -> UIColor {
        switch context {
        case .suburban:
            return RoadContextViewModel.subUrbainColor
        case .expressways:
            return RoadContextViewModel.highwayColor
        case .heavyUrbanTraffic:
            return RoadContextViewModel.urbainDenseColor
        case .city:
            return RoadContextViewModel.urbainFluidColor
        default:
            return RoadContextViewModel.backgroundColor
        }
    }
}
