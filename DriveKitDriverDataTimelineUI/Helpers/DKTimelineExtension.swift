// swiftlint:disable all
//
//  DKTimelineExtension.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Frédéric Ruaudel on 13/12/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

extension DKRawTimeline {
    
    var hasData: Bool {
        self.allContext.numberTripTotal.isEmpty == false
    }
    
    func selectedIndex(for selectedDate: Date?) -> Int? {
        let dates = self.allContext.date
        let selectedDateIndex: Int?
        if let date = selectedDate {
            selectedDateIndex = dates.firstIndex(of: date)
        } else if !dates.isEmpty {
            selectedDateIndex = dates.count - 1
        } else {
            selectedDateIndex = nil
        }
        return selectedDateIndex
    }
    
    /// Clean timeline to remove, if needed, values where there are only unscored trips.
    func cleaned(
        forScore score: DKScoreType,
        selectedIndex: Int?
    ) -> Self {
        let canInsertAtIndex: (Int) -> Bool = { index in
            self.hasValidTripScored(for: score, at: index) || index == selectedIndex
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
        var fuelSaving: [Double] = []
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
            if let currentDate = self.allContext.date[safe: index], canInsertAtIndex(index) {
                date.append(currentDate)
                self.allContext.numberTripTotal.appendIfNotEmpty(valueAtIndex: index, into: &numberTripTotal)
                self.allContext.numberTripScored.appendIfNotEmpty(valueAtIndex: index, into: &numberTripScored)
                self.allContext.distance.appendIfNotEmpty(valueAtIndex: index, into: &distance)
                self.allContext.duration.appendIfNotEmpty(valueAtIndex: index, into: &duration)
                self.allContext.efficiency.appendIfNotEmpty(valueAtIndex: index, into: &efficiency)
                self.allContext.safety.appendIfNotEmpty(valueAtIndex: index, into: &safety)
                self.allContext.acceleration.appendIfNotEmpty(valueAtIndex: index, into: &acceleration)
                self.allContext.braking.appendIfNotEmpty(valueAtIndex: index, into: &braking)
                self.allContext.adherence.appendIfNotEmpty(valueAtIndex: index, into: &adherence)
                self.allContext.phoneDistraction.appendIfNotEmpty(valueAtIndex: index, into: &phoneDistraction)
                self.allContext.speeding.appendIfNotEmpty(valueAtIndex: index, into: &speeding)
                self.allContext.co2Mass.appendIfNotEmpty(valueAtIndex: index, into: &co2Mass)
                self.allContext.fuelVolume.appendIfNotEmpty(valueAtIndex: index, into: &fuelVolume)
                self.allContext.fuelSaving.appendIfNotEmpty(valueAtIndex: index, into: &fuelSaving)
                self.allContext.unlock.appendIfNotEmpty(valueAtIndex: index, into: &unlock)
                self.allContext.lock.appendIfNotEmpty(valueAtIndex: index, into: &lock)
                self.allContext.callAuthorized.appendIfNotEmpty(valueAtIndex: index, into: &callAuthorized)
                self.allContext.callForbidden.appendIfNotEmpty(valueAtIndex: index, into: &callForbidden)
                self.allContext.callForbiddenDuration.appendIfNotEmpty(valueAtIndex: index, into: &callForbiddenDuration)
                self.allContext.callAuthorizedDuration.appendIfNotEmpty(valueAtIndex: index, into: &callAuthorizedDuration)
                self.allContext.numberTripWithForbiddenCall.appendIfNotEmpty(valueAtIndex: index, into: &numberTripWithForbiddenCall)
                self.allContext.speedingDuration.appendIfNotEmpty(valueAtIndex: index, into: &speedingDuration)
                self.allContext.speedingDistance.appendIfNotEmpty(valueAtIndex: index, into: &speedingDistance)
                self.allContext.efficiencyBrake.appendIfNotEmpty(valueAtIndex: index, into: &efficiencyBrake)
                self.allContext.efficiencyAcceleration.appendIfNotEmpty(valueAtIndex: index, into: &efficiencyAcceleration)
                self.allContext.efficiencySpeedMaintain.appendIfNotEmpty(valueAtIndex: index, into: &efficiencySpeedMaintain)
            }
        }

        var roadContexts: [DKRawTimeline.RoadContextItem] = []
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
            var fuelSaving: [Double] = []
            var efficiencyAcceleration: [Double] = []
            var efficiencyBrake: [Double] = []
            var efficiencySpeedMaintain: [Double] = []
            for index in 0..<maxItems {
                if let currentDate = roadContext.date[safe: index], canInsertAtIndex(index) {
                    date.append(currentDate)
                    roadContext.numberTripTotal.appendIfNotEmpty(valueAtIndex: index, into: &numberTripTotal)
                    roadContext.numberTripScored.appendIfNotEmpty(valueAtIndex: index, into: &numberTripScored)
                    roadContext.distance.appendIfNotEmpty(valueAtIndex: index, into: &distance)
                    roadContext.duration.appendIfNotEmpty(valueAtIndex: index, into: &duration)
                    roadContext.efficiency.appendIfNotEmpty(valueAtIndex: index, into: &efficiency)
                    roadContext.safety.appendIfNotEmpty(valueAtIndex: index, into: &safety)
                    roadContext.acceleration.appendIfNotEmpty(valueAtIndex: index, into: &acceleration)
                    roadContext.braking.appendIfNotEmpty(valueAtIndex: index, into: &braking)
                    roadContext.adherence.appendIfNotEmpty(valueAtIndex: index, into: &adherence)
                    roadContext.co2Mass.appendIfNotEmpty(valueAtIndex: index, into: &co2Mass)
                    roadContext.fuelVolume.appendIfNotEmpty(valueAtIndex: index, into: &fuelVolume)
                    roadContext.fuelSaving.appendIfNotEmpty(valueAtIndex: index, into: &fuelSaving)
                    roadContext.efficiencyAcceleration.appendIfNotEmpty(valueAtIndex: index, into: &efficiencyAcceleration)
                    roadContext.efficiencyBrake.appendIfNotEmpty(valueAtIndex: index, into: &efficiencyBrake)
                    roadContext.efficiencySpeedMaintain.appendIfNotEmpty(valueAtIndex: index, into: &efficiencySpeedMaintain)
                }
            }
            let newRoadContext = DKRawTimeline.RoadContextItem(
                type: roadContext.type,
                date: date,
                numberTripTotal: numberTripTotal,
                numberTripScored: numberTripScored,
                distance: distance,
                duration: duration,
                efficiency: efficiency,
                safety: safety,
                acceleration: acceleration,
                braking: braking,
                adherence: adherence,
                co2Mass: co2Mass,
                fuelVolume: fuelVolume,
                fuelSaving: fuelSaving,
                efficiencyAcceleration: efficiencyAcceleration,
                efficiencyBrake: efficiencyBrake,
                efficiencySpeedMaintain: efficiencySpeedMaintain
            )
            roadContexts.append(newRoadContext)
        }

        let allContext: DKRawTimeline.AllContextItem = DKRawTimeline.AllContextItem(
            date: date,
            numberTripTotal: numberTripTotal,
            numberTripScored: numberTripScored,
            distance: distance,
            duration: duration,
            efficiency: efficiency,
            safety: safety,
            acceleration: acceleration,
            braking: braking,
            adherence: adherence,
            phoneDistraction: phoneDistraction,
            speeding: speeding,
            co2Mass: co2Mass,
            fuelVolume: fuelVolume,
            fuelSaving: fuelSaving,
            unlock: unlock,
            lock: lock,
            callAuthorized: callAuthorized,
            callForbidden: callForbidden,
            callAuthorizedDuration: callAuthorizedDuration,
            callForbiddenDuration: callForbiddenDuration,
            numberTripWithForbiddenCall: numberTripWithForbiddenCall,
            speedingDuration: speedingDuration,
            speedingDistance: speedingDistance,
            efficiencyBrake: efficiencyBrake,
            efficiencyAcceleration: efficiencyAcceleration,
            efficiencySpeedMaintain: efficiencySpeedMaintain
        )
        let cleanedTimeline = DKRawTimeline(period: self.period, allContext: allContext, roadContexts: roadContexts)
        return cleanedTimeline
    }
    
    /// Compute distance by road contexts from the timeline
    func distanceByRoadContext(
        selectedScore: DKScoreType,
        selectedIndex: Int
    ) -> [TimelineRoadContext: Double] {
        var distanceByContext: [TimelineRoadContext: Double] = [:]
        if self.hasValidTripScored(for: selectedScore, at: selectedIndex) {
            for roadContext in self.roadContexts {
                if let timelineRoadContext = TimelineRoadContext(roadContext: roadContext.type) {
                    let distance = roadContext.distance[selectedIndex, default: 0]
                    if distance > 0 {
                        distanceByContext[timelineRoadContext] = distance
                    }
                }
            }
        }
        
        return distanceByContext
    }

    func totalDistanceForAllContexts(
        selectedScore: DKScoreType,
        selectedIndex: Int
    ) -> Double {
        var totalDistanceForAllContexts: Double = 0
        if self.hasValidTripScored(for: selectedScore, at: selectedIndex) {
            totalDistanceForAllContexts = self.allContext.distance[selectedIndex, default: 0]
        }
        
        return totalDistanceForAllContexts
    }
    
    func hasValidTripScored(
        for selectedScore: DKScoreType,
        at index: Int
    ) -> Bool {
        // Distraction and Speeding can have score for short trip which
        // are not counted in `numberTripScored`. `numberTripScored` only
        // count fully scored trip for all four scores
        return selectedScore == .distraction
            || selectedScore == .speeding
            || self.allContext.numberTripScored[index, default: 0] > 0
    }
}
