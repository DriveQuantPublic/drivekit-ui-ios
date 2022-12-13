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
    
    func cleaned(
        forScore score: DKTimelineScoreType,
        selectedIndex: Int?
    ) -> Self {
        let canInsertAtIndex: (Int) -> Bool = { index in
            self.allContext.numberTripScored[index] > 0 || score == .distraction || score == .speeding || index == selectedIndex
        }
        var date: [Date] = []
        var numberTripTotal: [Int] = []
        var numberTripScored: [Int] = []
        var distance: [Double] = []
        var duration: [Int] = []
        var efficiency: [Double] = []
        var safety: [Double] = []
        var acceleration: [Int] = []
        var braking: [Int] = []
        var adherence: [Int] = []
        var phoneDistraction: [Double] = []
        var speeding: [Double] = []
        var co2Mass: [Double] = []
        var fuelVolume: [Double] = []
        var unlock: [Int] = []
        var lock: [Int] = []
        var callAuthorized: [Int] = []
        var callForbidden: [Int] = []
        var callForbiddenDuration: [Int] = []
        var callAuthorizedDuration: [Int] = []
        var numberTripWithForbiddenCall: [Int] = []
        var speedingDuration: [Int] = []
        var speedingDistance: [Double] = []
        var efficiencyBrake: [Double] = []
        var efficiencyAcceleration: [Double] = []
        var efficiencySpeedMaintain: [Double] = []
        let maxItems = self.allContext.date.count
        for index in 0..<maxItems {
            if canInsertAtIndex(index) {
                date.append(self.allContext.date[index])
                numberTripTotal.append(self.allContext.numberTripTotal[index])
                numberTripScored.append(self.allContext.numberTripScored[index])
                distance.append(self.allContext.distance[index])
                duration.append(self.allContext.duration[index])
                efficiency.append(self.allContext.efficiency[index])
                safety.append(self.allContext.safety[index])
                acceleration.append(self.allContext.acceleration[index])
                braking.append(self.allContext.braking[index])
                adherence.append(self.allContext.adherence[index])
                phoneDistraction.append(self.allContext.phoneDistraction[index])
                speeding.append(self.allContext.speeding[index])
                co2Mass.append(self.allContext.co2Mass[index])
                fuelVolume.append(self.allContext.fuelVolume[index])
                unlock.append(self.allContext.unlock[index])
                lock.append(self.allContext.lock[index])
                callAuthorized.append(self.allContext.callAuthorized[index])
                callForbidden.append(self.allContext.callForbidden[index])
                callForbiddenDuration.append(self.allContext.callForbiddenDuration[index])
                callAuthorizedDuration.append(self.allContext.callAuthorizedDuration[index])
                if !self.allContext.numberTripWithForbiddenCall.isEmpty {
                    numberTripWithForbiddenCall.append(self.allContext.numberTripWithForbiddenCall[index])
                    speedingDuration.append(self.allContext.speedingDuration[index])
                    speedingDistance.append(self.allContext.speedingDistance[index])
                    efficiencyBrake.append(self.allContext.efficiencyBrake[index])
                    efficiencyAcceleration.append(self.allContext.efficiencyAcceleration[index])
                    efficiencySpeedMaintain.append(self.allContext.efficiencySpeedMaintain[index])
                }
            }
        }

        var roadContexts: [DKTimeline.RoadContextItem] = []
        for roadContext in self.roadContexts {
            var date: [Date] = []
            var numberTripTotal: [Int] = []
            var numberTripScored: [Int] = []
            var distance: [Double] = []
            var duration: [Int] = []
            var efficiency: [Double] = []
            var safety: [Double] = []
            var acceleration: [Int] = []
            var braking: [Int] = []
            var adherence: [Int] = []
            var co2Mass: [Double] = []
            var fuelVolume: [Double] = []
            var efficiencyAcceleration: [Double] = []
            var efficiencyBrake: [Double] = []
            var efficiencySpeedMaintain: [Double] = []
            for index in 0..<maxItems {
                if canInsertAtIndex(index) {
                    date.append(roadContext.date[index])
                    numberTripTotal.append(roadContext.numberTripTotal[index])
                    numberTripScored.append(roadContext.numberTripScored[index])
                    distance.append(roadContext.distance[index])
                    duration.append(roadContext.duration[index])
                    efficiency.append(roadContext.efficiency[index])
                    safety.append(roadContext.safety[index])
                    acceleration.append(roadContext.acceleration[index])
                    braking.append(roadContext.braking[index])
                    adherence.append(roadContext.adherence[index])
                    co2Mass.append(roadContext.co2Mass[index])
                    fuelVolume.append(roadContext.fuelVolume[index])
                    if !roadContext.efficiencyAcceleration.isEmpty {
                        efficiencyAcceleration.append(roadContext.efficiencyAcceleration[index])
                        efficiencyBrake.append(roadContext.efficiencyBrake[index])
                        efficiencySpeedMaintain.append(roadContext.efficiencySpeedMaintain[index])
                    }
                }
            }
            let newRoadContext = DKTimeline.RoadContextItem(type: roadContext.type, date: date, numberTripTotal: numberTripTotal, numberTripScored: numberTripScored, distance: distance, duration: duration, efficiency: efficiency, safety: safety, acceleration: acceleration, braking: braking, adherence: adherence, co2Mass: co2Mass, fuelVolume: fuelVolume, efficiencyAcceleration: efficiencyAcceleration, efficiencyBrake: efficiencyBrake, efficiencySpeedMaintain: efficiencySpeedMaintain)
            roadContexts.append(newRoadContext)
        }

        let allContext: DKTimeline.AllContextItem = DKTimeline.AllContextItem(date: date, numberTripTotal: numberTripTotal, numberTripScored: numberTripScored, distance: distance, duration: duration, efficiency: efficiency, safety: safety, acceleration: acceleration, braking: braking, adherence: adherence, phoneDistraction: phoneDistraction, speeding: speeding, co2Mass: co2Mass, fuelVolume: fuelVolume, unlock: unlock, lock: lock, callAuthorized: callAuthorized, callForbidden: callForbidden, callAuthorizedDuration: callAuthorizedDuration, callForbiddenDuration: callForbiddenDuration, numberTripWithForbiddenCall: numberTripWithForbiddenCall, speedingDuration: speedingDuration, speedingDistance: speedingDistance, efficiencyBrake: efficiencyBrake, efficiencyAcceleration: efficiencyAcceleration, efficiencySpeedMaintain: efficiencySpeedMaintain)
        let cleanedTimeline = DKTimeline(period: self.period, allContext: allContext, roadContexts: roadContexts)
        return cleanedTimeline
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
