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

    init(distanceByContext: [DKRoadContext : Double], distance: Double) {
        self.distanceByContext = distanceByContext
        self.distance = distance
    }

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
}
