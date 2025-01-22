//
//  SynthesisCardUtils.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 28/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

// swiftlint:disable:next convenience_type
public struct SynthesisCardUtils {

    public static func getLastTrip(withTransportationModes transportationModes: [TransportationMode] = [.unknown, .car, .moto, .truck]) -> DKTrip? {
        let tripsQuery = getTripsQuery(forTransportationModes: transportationModes)
        let lastTrip = tripsQuery
            .orderBy(field: "endDate", ascending: false)
            .query()
            .limit(limit: 1)
            .execute()
        return lastTrip.first
    }

    public static func getLastTrips(withTransportationModes transportationModes: [TransportationMode] = [.unknown, .car, .moto, .truck]) -> [DKTrip] {
        if let lastTrip = getLastTrip(withTransportationModes: transportationModes), let lastDate = lastTrip.endDate {
            let sevenDaysInSeconds: TimeInterval = 604_800// 7 * 24 * 3_600
            let oneWeekBeforeDate = lastDate.addingTimeInterval(-sevenDaysInSeconds)
            let tripsQuery = getTripsQuery(forTransportationModes: transportationModes)
            let lastTrips = tripsQuery
                .and()
                .whereGreaterThanOrEqual(field: "endDate", value: oneWeekBeforeDate)
                .orderBy(field: "endDate", ascending: false)
                .query()
                .execute()
            return lastTrips
        } else {
            return []
        }
    }

    public static func getMainRoadCondition(ofTrips trips: [DKTrip], forType type: RoadConditionType = .ecoDriving) -> (DKRoadCondition, Double) {
        let roadConditionStats = RoadConditionStats(type: type, trips: trips)
        return roadConditionStats.roadConditionPercentages
            .filter { $0.key != .trafficJam }
            .sorted { $0.key.rawValue < $1.key.rawValue }
            .max { $0.value < $1.value }!
    }

    private static func getTripsQuery(forTransportationModes transportationModes: [TransportationMode]) -> Query<DBTrip, DKTrip> {
        let transportationModesValues = transportationModes.map { $0.rawValue }
        let tripsQuery = DriveKitDriverData.shared.tripsQuery()
            .whereIn(field: "transportationMode", value: transportationModesValues)
        return tripsQuery
    }
}

public struct RoadConditionStats {
    public let roadConditionType: RoadConditionType
    public let roadConditionPercentages: [DKRoadCondition: Double]

    init(type: RoadConditionType, trips: [DKTrip]) {
        self.roadConditionType = type
        let tripNumber = Double(trips.count)
        if tripNumber > 0 {
            var mainRoadConditionCount: [DKRoadCondition: Int] = [:]
            for trip in trips {
                let roadConditionObjects: [RoadConditionObject]?
                switch type {
                    case .ecoDriving:
                        roadConditionObjects = trip.ecoDrivingContexts
                    case .safety:
                        roadConditionObjects = trip.safetyContexts
                }

                var mainRoadCondition: DKRoadCondition?
                var maxDistance: Double = 0
                if let roadConditionObjects = roadConditionObjects {
                    for roadConditionObject in roadConditionObjects {
                        if let roadCondition = roadConditionObject.roadCondition, roadCondition != .trafficJam, roadConditionObject.distance > maxDistance {
                            mainRoadCondition = roadCondition
                            maxDistance = roadConditionObject.distance
                        }
                    }
                }
                if let mainRoadCondition = mainRoadCondition {
                    mainRoadConditionCount[mainRoadCondition] = (mainRoadConditionCount[mainRoadCondition] ?? 0) + 1
                }
            }
            var roadConditionPercentages: [DKRoadCondition: Double] = [:]
            for roadCondition in DKRoadCondition.allCases where roadCondition != .trafficJam {
                let oneHundred: Double = 100
                roadConditionPercentages[roadCondition] = Double(mainRoadConditionCount[roadCondition] ?? 0) / tripNumber * oneHundred
        }
            self.roadConditionPercentages = roadConditionPercentages
        } else {
            var roadConditionPercentages: [DKRoadCondition: Double] = [:]
            for roadCondition in DKRoadCondition.allCases where roadCondition != .trafficJam {
                roadConditionPercentages[roadCondition] = 0
            }
            self.roadConditionPercentages = roadConditionPercentages
        }
    }
}

public enum RoadConditionType {
    case safety, ecoDriving
}

private protocol RoadConditionObject: AnyObject {
    var distance: Double { get }
    var contextId: Int32 { get }
    var roadCondition: DKRoadCondition? { get }
}

extension DKSafetyContext: RoadConditionObject { }
extension DKEcoDrivingContext: RoadConditionObject { }
