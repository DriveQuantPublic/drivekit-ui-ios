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
    weak var delegate: RoadContextViewModelDelegate?

    private var items: [TimelineRoadContext] = []

    func configure(
        with selectedScore: DKScoreType,
        timeline: DKRawTimeline?,
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
                @unknown default:
                    roadContextType = .noData(totalDistanceForAllContexts: totalDistanceForAllContexts)
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
        self.updateItems()
        self.delegate?.roadContextViewModelDidUpdate()
    }

    private func updateItems() {
        var result: [TimelineRoadContext] = []
        for context: TimelineRoadContext in [.heavyUrbanTraffic(), .city(), .suburban(), .expressways()] {
            
            let contextPercent = self.getContextPercent(context)
            if contextPercent > 0,
                let timelineRoadContext = TimelineRoadContext(roadContext: context.getRoadContext(), percent: contextPercent) {
                result.append(timelineRoadContext)
            }
        }
        self.items = result
    }

    private func getContextPercent(_ context: TimelineRoadContext) -> Double {
        guard let contextDistance = roadContextType.distanceByContext[context] else {
            return 0
        }
        return contextDistance / totalDistanceForDisplayedContexts
    }
    
    func hasData() -> Bool {
        return roadContextType.hasData
    }
}
extension RoadContextViewModel: DKContextCard {
    func getItems() -> [DKContextItem] {
        return items
    }
    
    func getTitle() -> String {
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
    
    func getEmptyDataDescription() -> String {
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
}

protocol RoadContextViewModelDelegate: AnyObject {
    func roadContextViewModelDidUpdate()
}

enum TimelineRoadContext: Codable, Hashable {
    case heavyUrbanTraffic(percent: Double = 0)
    case city(percent: Double = 0)
    case suburban(percent: Double = 0)
    case expressways(percent: Double = 0)

    init?(roadContext: DKRoadContext, percent: Double = 0) {
        switch roadContext {
        case .heavyUrbanTraffic:
            self = .heavyUrbanTraffic(percent: percent)
        case .city:
            self = .city(percent: percent)
        case .suburban:
            self = .suburban(percent: percent)
        case .expressways:
            self = .expressways(percent: percent)
        default:
            return nil
        }
    }
    func getRoadContext() -> DKRoadContext {
        switch self {
            case .heavyUrbanTraffic(_):
                return .heavyUrbanTraffic
            case .city(_):
                return .city
            case .suburban(_):
                return .suburban
            case .expressways(_):
                return .expressways
        }
    }
}


extension TimelineRoadContext: DKContextItem {
    func getPercent() -> Double {
        switch self {
            case .heavyUrbanTraffic(let percent):
                return percent
            case .city(let percent):
                return percent
            case .suburban(let percent):
                return percent
            case .expressways(let percent):
                return percent
        }
    }
    
    private static let heavyUrbanTrafficColor = UIColor(hex: 0x036A82).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let suburbanColor = UIColor(hex: 0x699DAD).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let cityColor = UIColor(hex: 0x3B8497).tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let expresswaysColor = UIColor(hex: 0x8FB7C2).tinted(usingHueOf: DKUIColors.primaryColor.color)

    func getColor() -> UIColor {
        switch self {
        case .suburban:
            return TimelineRoadContext.suburbanColor
        case .expressways:
            return TimelineRoadContext.expresswaysColor
        case .heavyUrbanTraffic:
            return TimelineRoadContext.heavyUrbanTrafficColor
        case .city:
            return TimelineRoadContext.cityColor
        }
    }
    
    func getTitle() -> String {
        switch self {
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

    func getSubtitle() -> String? {
        return nil
    }
    
}
