// swiftlint:disable all
//
//  RoadContextViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import UIKit

enum RoadContextType {
    case data(
        distanceByContext: [TimelineRoadContext: Double],
        totalDistanceForAllContexts: Double
    )
    case emptyData
    case noData(totalDistanceForAllContexts: Double)
    case noDataSafety
    case noDataEcodriving
    
    var hasData: Bool {
        switch self {
        case .data:
            return true
        case .noData, .emptyData, .noDataSafety, .noDataEcodriving:
            return false
        }
    }
    
    var distanceByContext: [TimelineRoadContext: Double] {
        switch self {
        case let .data(distanceByContext, _):
            return distanceByContext
        case .noData, .emptyData, .noDataSafety, .noDataEcodriving:
            return [:]
        }
    }
    
    var totalDistanceForAllContexts: Double {
        switch self {
        case let .data(_, totalDistanceForAllContexts),
            let .noData(totalDistanceForAllContexts):
            return totalDistanceForAllContexts
        case .emptyData, .noDataSafety, .noDataEcodriving:
            return 0
        }
    }
}

class RoadContextViewModel {
    private var roadContextType: RoadContextType = .emptyData
    private var totalDistanceForDisplayedContexts: Double = 0
    private static let backgroundColor = UIColor(hex: 0xFAFAFA)
    private static let heavyUrbanTrafficColor = UIColor(hex: 0x036A82).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let suburbanColor = UIColor(hex: 0x699DAD).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let cityColor = UIColor(hex: 0x3B8497).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let expresswaysColor = UIColor(hex: 0x8FB7C2).tinted(usingHueOf: DKUIColors.primaryColor.color)
    weak var delegate: RoadContextViewModelDelegate?

    var hasData: Bool {
        roadContextType.hasData
    }
    
    var itemsToDraw: [(context: TimelineRoadContext, percent: Double)] = []

    var title: String {
        switch self.roadContextType {
            case let .data(_, totalDistanceForAllContexts),
            let .noData(totalDistanceForAllContexts):
            return String(
                format: "dk_timeline_road_context_title".dkDriverDataTimelineLocalized(),
                totalDistanceForAllContexts.formatKilometerDistance(
                    minDistanceToRemoveFractions: 10
                )
            )
            case .emptyData:
                return "dk_timeline_road_context_title_empty_data".dkDriverDataTimelineLocalized()
            case .noDataSafety:
                return "dk_timeline_road_context_title_no_data".dkDriverDataTimelineLocalized()
            case .noDataEcodriving:
                return "dk_timeline_road_context_title_no_data".dkDriverDataTimelineLocalized()
        }
    }
    
    var emptyDataDescription: String {
        switch roadContextType {
            case .data:
                assertionFailure("We should not display emptyDataDescription when we have data")
                return ""
            case .emptyData:
                return "dk_timeline_road_context_description_empty_data".dkDriverDataTimelineLocalized()
            case .noData:
                return "dk_timeline_road_context_no_context_description".dkDriverDataTimelineLocalized()
            case .noDataSafety:
                return "dk_timeline_road_context_description_no_data_safety".dkDriverDataTimelineLocalized()
            case .noDataEcodriving:
                return "dk_timeline_road_context_description_no_data_ecodriving".dkDriverDataTimelineLocalized()
        }
    }
    
    func configure(
        with selectedScore: DKScoreType,
        timeline: DKTimeline?,
        selectedIndex: Int? = nil
    ) {
        if let timeline, let selectedIndex, timeline.hasData {
            var distanceByContext: [TimelineRoadContext: Double] = [:]
            var totalDistanceForAllContexts: Double = 0
            
            distanceByContext = timeline.distanceByRoadContext(
                selectedScore: selectedScore,
                selectedIndex: selectedIndex
            )
            totalDistanceForAllContexts = timeline.totalDistanceForAllContexts(
                selectedScore: selectedScore,
                selectedIndex: selectedIndex
            )
            
            if distanceByContext.isEmpty {
                switch selectedScore {
                case .distraction, .speeding:
                    roadContextType = .noData(totalDistanceForAllContexts: totalDistanceForAllContexts)
                case .safety:
                    roadContextType = .noDataSafety
                case .ecoDriving:
                    roadContextType = .noDataEcodriving
                }
            } else {
                roadContextType = .data(
                    distanceByContext: distanceByContext,
                    totalDistanceForAllContexts: totalDistanceForAllContexts
                )
            }
        } else {
            roadContextType = .emptyData
        }
        
        self.totalDistanceForDisplayedContexts = roadContextType.distanceByContext.reduce(
            into: 0.0
        ) { distance, element in
            distance += element.value
        }
        self.updateItemsToDraw()
        self.delegate?.roadContextViewModelDidUpdate()
    }

    private func updateItemsToDraw() {
        var result: [(context: TimelineRoadContext, percent: Double)] = []
        for context: TimelineRoadContext in [.heavyUrbanTraffic, .city, .suburban, .expressways] {
            let contextPercent = getPercent(context: context)
            if contextPercent > 0 {
                result.append((context, contextPercent))
            }
        }
        self.itemsToDraw = result
    }
    
    func getActiveContextNumber() -> Int {
        var total: Int = 0
        for (_, dist) in roadContextType.distanceByContext {
            if dist > 0 {
                total = total + 1
            }
        }
        return total
    }

    func getPercent(context: TimelineRoadContext) -> Double {
        guard let contextDistance = roadContextType.distanceByContext[context] else {
            return 0
        }
        return contextDistance / totalDistanceForDisplayedContexts
    }

    static func getRoadContextColor(_ context: TimelineRoadContext) -> UIColor {
        switch context {
        case .suburban:
            return RoadContextViewModel.suburbanColor
        case .expressways:
            return RoadContextViewModel.expresswaysColor
        case .heavyUrbanTraffic:
            return RoadContextViewModel.heavyUrbanTrafficColor
        case .city:
            return RoadContextViewModel.cityColor
        }
    }

    static func getRoadContextTitle(_ context: TimelineRoadContext) -> String {
        switch context {
        case .suburban:
            return "dk_timeline_road_context_suburban".dkDriverDataTimelineLocalized()
        case .expressways:
            return "dk_timeline_road_context_expressways".dkDriverDataTimelineLocalized()
        case .heavyUrbanTraffic:
            return "dk_timeline_road_context_heavy_urban_traffic".dkDriverDataTimelineLocalized()
        case .city:
            return "dk_timeline_road_context_city".dkDriverDataTimelineLocalized()
        }
    }
}

protocol RoadContextViewModelDelegate: AnyObject {
    func roadContextViewModelDidUpdate()
}

enum TimelineRoadContext: Int, Codable {
    case heavyUrbanTraffic
    case city
    case suburban
    case expressways

    init?(roadContext: DKRoadContext) {
        switch roadContext {
        case .heavyUrbanTraffic:
            self = .heavyUrbanTraffic
        case .city:
            self = .city
        case .suburban:
            self = .suburban
        case .expressways:
            self = .expressways
        default:
            return nil
        }
    }
}
