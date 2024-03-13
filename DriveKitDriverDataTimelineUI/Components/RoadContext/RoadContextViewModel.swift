// swiftlint:disable no_magic_numbers
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

    var hasData: Bool {
        switch self {
        case .data:
            return true
        case .noData, .emptyData:
            return false
        }
    }
    
    var distanceByContext: [TimelineRoadContext: Double] {
        switch self {
        case let .data(distanceByContext, _):
            return distanceByContext
        case .noData, .emptyData:
            return [:]
        }
    }
}

class RoadContextViewModel {
    private var roadContextType: RoadContextType = .emptyData
    private var totalDistanceForDisplayedContexts: Double = 0
    weak var delegate: RoadContextViewModelDelegate?

    var hasData: Bool {
        roadContextType.hasData
    }

    private var roadContextItems: [TimelineRoadContext] = []

    func configure(
        timeline: DKDriverTimeline?,
        selectedDate: Date? = nil
    ) {
        if let timeline, let selectedDate {
            let distanceByContext = timeline.roadContexts.reduce(into: [TimelineRoadContext: Double]()) { partialResult, roadContextsElement in
                if let distance = roadContextsElement.value.first(where: { $0.date == selectedDate })?.distance, distance > 0 {
                    if let timelineRoadContext = TimelineRoadContext(roadContext: roadContextsElement.key) {
                        partialResult[timelineRoadContext] = distance
                    }
                }
            }
            let totalDistanceForAllContexts = timeline.allContext.first { $0.date == selectedDate }?.distance ?? 0

            if distanceByContext.isEmpty {
                roadContextType = .noData(totalDistanceForAllContexts: totalDistanceForAllContexts)
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
        for context: TimelineRoadContext in [.heavyUrbanTraffic, .city, .suburban, .expressways] {
            
            let contextPercent = self.getContextPercent(context)
            if contextPercent > 0 {
                result.append(context)
            }
        }
        self.roadContextItems = result
    }

    func getContextPercent(_ context: some DKContextItem) -> Double {
        guard let roadContext = context as? TimelineRoadContext,
                let contextDistance = roadContextType.distanceByContext[roadContext] else {
            return 0
        }
        return contextDistance / totalDistanceForDisplayedContexts
    }    
}
extension RoadContextViewModel: DKContextCard {
    var items: [DriveKitCommonUI.DKContextItem] {
        return roadContextItems
    }
    
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
                return DKCommonLocalizable.noDataYet.text()
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
        }
    }
    func contextCardDidUpdate(_ completionHandler: (() -> Void)?) {
        // not needed
    }
}

protocol RoadContextViewModelDelegate: AnyObject {
    func roadContextViewModelDidUpdate()
}

enum TimelineRoadContext: Codable, Hashable {
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

extension TimelineRoadContext: DKContextItem {
    private static let heavyUrbanTrafficColor = DKContextCardColor.level1.color.tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let cityColor = DKContextCardColor.level2.color.tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let suburbanColor = DKContextCardColor.level3.color.tinted(usingHueOf: DKUIColors.primaryColor.color)
    private static let expresswaysColor = DKContextCardColor.level4.color.tinted(usingHueOf: DKUIColors.primaryColor.color)

    var color: UIColor {
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

    var title: String {
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

    var subtitle: String? {
        return nil
    }
}
