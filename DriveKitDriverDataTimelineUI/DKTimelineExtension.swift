//
//  DKTimelineExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 13/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//
import Foundation
import DriveKitDBTripAccessModule

extension DKTimeline {
    
    var hasData: Bool {
        self.allContext.numberTripTotal.isEmpty == false
    }
    
    /// Compute distance by road contexts from the timeline
    func distanceByRoadContext(
        selectedScore: DKTimelineScoreType,
        selectedIndex: Int
    ) -> [TimelineRoadContext: Double] {
        var distanceByContext: [TimelineRoadContext: Double] = [:]
        if self.hasValidTripScored(for: selectedScore, selectedIndex: selectedIndex) {
            for roadContext in self.roadContexts {
                if let timelineRoadContext = TimelineRoadContext(roadContext: roadContext.type) {
                    let distance = roadContext.distance[selectedIndex]
                    if distance > 0 {
                        distanceByContext[timelineRoadContext] = distance
                    }
                }
            }
        }
        
        return distanceByContext
    }

    func totalDistanceForAllContexts(
        selectedScore: DKTimelineScoreType,
        selectedIndex: Int
    ) -> Double {
        var totalDistanceForAllContexts: Double = 0
        if self.hasValidTripScored(for: selectedScore, selectedIndex: selectedIndex) {
            totalDistanceForAllContexts = self.allContext.distance[selectedIndex]
        }
        
        return totalDistanceForAllContexts
    }
    
    private func hasValidTripScored(
        for selectedScore: DKTimelineScoreType,
        selectedIndex: Int
    ) -> Bool {
        // Distraction and Speeding can have score for short trip which
        // are not counted in `numberTripScored`. `numberTripScored` only
        // count fully scored trip for all four scores
        return selectedScore == .distraction
            || selectedScore == .speeding
            || self.allContext.numberTripScored[selectedIndex] > 0
    }
}
