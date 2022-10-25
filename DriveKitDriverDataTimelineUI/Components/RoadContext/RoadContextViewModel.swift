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
    private static let heavyUrbanTrafficColor = UIColor(hex: 0x036A82)
    private static let suburbanColor = UIColor(hex: 0x699DAD)
    private static let cityColor = UIColor(hex: 0x3B8497)
    private static let expresswaysColor = UIColor(hex: 0x8FB7C2)

    init(distanceByContext: [DKRoadContext: Double], distance: Double) {
        self.distanceByContext = distanceByContext
        self.distance = distance
    }

    lazy var itemsToDraw: [(context: DKRoadContext, percent: Double)] = {
        var result: [(context: DKRoadContext, percent: Double)] = []
        for context: DKRoadContext in [.heavyUrbanTraffic, .city, .suburban, .expressways] {
            let contextPercent = getPercent(context: context)
            if contextPercent > 0 {
                result.append((context, contextPercent))
            }
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

    func getPercent(context: DKRoadContext) -> Double {
        guard let distance = distanceByContext[context] else {
            return 0
        }
        return distance/totalCalculatedDistance
    }

    static func getContextColor(_ context: DKRoadContext) -> UIColor {
        switch context {
        case .suburban:
            return RoadContextViewModel.suburbanColor
        case .expressways:
            return RoadContextViewModel.expresswaysColor
        case .heavyUrbanTraffic:
            return RoadContextViewModel.heavyUrbanTrafficColor
        case .city:
            return RoadContextViewModel.cityColor
        default:
            return RoadContextViewModel.backgroundColor
        }
    }
}
