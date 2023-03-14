//
//  MySynthesisCommunityCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

public class MySynthesisCommunityCardViewModel {
    private var scoreSynthesis: DKScoreSynthesis?
    private var hasOnlyShortTripsForCurrentPeriod: Bool = false
    private var userTripCount: Int?
    private var userDistanceCount: Double?
    private var communityStatistics: DKCommunityStatistics?
    private(set) var synthesisGaugeViewModel: MySynthesisGaugeViewModel = MySynthesisGaugeViewModel()

    var communityCardViewModelDidUpdate: (() -> Void)?
    
    public init() {}
    
    public var title: String {
        switch tripKind {
            case .noTrip:
                return "dk_driverdata_mysynthesis_no_driving".dkDriverDataLocalized()
            case .onlyShortTrips:
                switch scoreSynthesis?.scoreType {
                    case .safety, .ecoDriving, .none:
                        return "dk_driverdata_mysynthesis_not_enough_data".dkDriverDataLocalized()
                    case .distraction, .speeding:
                        return userCommunityRelatedPositionDescription
                }
            case .scoredTrips:
                return userCommunityRelatedPositionDescription
        }
    }
    
    public var titleColor: DKUIColors {
        switch tripKind {
            case .noTrip:
                return .complementaryFontColor
            case .onlyShortTrips:
                switch scoreSynthesis?.scoreType {
                    case .safety, .ecoDriving, .none:
                        return .complementaryFontColor
                    case .distraction, .speeding:
                        return .primaryColor
                }

            case .scoredTrips:
                return .primaryColor
        }
    }
        
    public func configure(
        with scoreSynthesis: DKScoreSynthesis,
        hasOnlyShortTripsForCurrentPeriod: Bool,
        userTripCount: Int,
        userDistanceCount: Double,
        communityStatistics: DKCommunityStatistics
    ) {
        self.scoreSynthesis = scoreSynthesis
        self.hasOnlyShortTripsForCurrentPeriod = hasOnlyShortTripsForCurrentPeriod
        self.userTripCount = userTripCount
        self.userDistanceCount = userDistanceCount
        self.communityStatistics = communityStatistics
        if let scoreStatistics = communityStatistics.scoreStatistics(for: scoreSynthesis.scoreType) {
            self.synthesisGaugeViewModel.configure(
                scoreType: scoreSynthesis.scoreType,
                mean: scoreStatistics.mean,
                median: scoreStatistics.median,
                min: scoreStatistics.min,
                max: scoreStatistics.max,
                score: scoreSynthesis.scoreValue)
        }
        communityCardViewModelDidUpdate?()
    }
    
    public var userCommunityStatsItemViewModel: CommunityStatsItemViewModel {
        return .init(
            legendColor: .white,
            legendTitle: "dk_driverdata_mysynthesis_my_community".dkDriverDataLocalized(),
            tripCount: communityStatistics?.tripNumber,
            distanceCount: communityStatistics?.distance,
            driverCount: communityStatistics?.activeDriverNumber
        )
    }
    
    public var userStatsItemViewModel: CommunityStatsItemViewModel {
        return .init(
            legendColor: MySynthesisConstants.defaultColor,
            legendTitle: "dk_driverdata_mysynthesis_me".dkDriverDataLocalized(),
            tripCount: userTripCount,
            distanceCount: userDistanceCount
        )
    }
    
    // MARK: - Private Helpers
    private enum TripKind {
        case noTrip, onlyShortTrips, scoredTrips
    }
    
    private var tripKind: TripKind {
        guard let userTripCount else { return .noTrip }
        
        return userTripCount > 0
            ? .scoredTrips
            : hasOnlyShortTripsForCurrentPeriod
                ? .onlyShortTrips
                : .noTrip
    }
    
    private var userCommunityRelatedPositionDescription: String {
        guard
            let currentScore = scoreSynthesis?.scoreValue,
            let scoreType = scoreSynthesis?.scoreType,
            let scoreStatistics = communityStatistics?.scoreStatistics(for: scoreType)
        else {
            assertionFailure("We should have a score type and we should not display score type we don't have access to")
            return "-"
        }
        
        let bestThanCommunityThreshold = 55
        let worstThanCommunityThreshold = 45
        let userPositionFromLowerScores = scoreStatistics.percentOfCommunity(withScoreLowerThan: currentScore)
        let userPositionFromHigherScores = scoreStatistics.percentOfCommunity(withScoreGreaterThan: currentScore)
        
        if userPositionFromLowerScores > bestThanCommunityThreshold {
            return String(
                format: "dk_driverdata_mysynthesis_you_are_best".dkDriverDataLocalized(),
                Double(userPositionFromLowerScores).formatPercentage()
            )
        } else if userPositionFromLowerScores < worstThanCommunityThreshold {
            return String(
                format: "dk_driverdata_mysynthesis_you_are_lower".dkDriverDataLocalized(),
                Double(userPositionFromHigherScores).formatPercentage()
            )
        } else {
            return "dk_driverdata_mysynthesis_you_are_average".dkDriverDataLocalized()
        }
    }
}

extension DKScoreStatistics {
    var median: Double {
        guard !self.percentiles.isEmpty else {
            return 0
        }
        // swiftlint:disable:next no_magic_numbers
        let middleIndex = percentiles.count / 2
        return self.percentiles[middleIndex]
    }
}
