//
//  MySynthesisScoreCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import Foundation

public class MySynthesisScoreCardViewModel {
    private var period: DKPeriod?
    private var previousPeriodDate: Date?
    private var scoreSynthesis: DKScoreSynthesis?
    private var hasOnlyShortTripsForCurrentPeriod: Bool = false
    private var hasOnlyShortTripsForPreviousPeriod: Bool = false
    var scoreCardViewModelDidUpdate: (() -> Void)?
    
    public init() {}
    
    public var cardTitle: String {
        switch scoreSynthesis?.scoreType {
            case .safety:
                return "dk_driverdata_mysynthesis_safety_score".dkDriverDataLocalized()
            case .ecoDriving:
                return "dk_driverdata_mysynthesis_ecodriving_score".dkDriverDataLocalized()
            case .distraction:
                return "dk_driverdata_mysynthesis_distraction_score".dkDriverDataLocalized()
            case .speeding:
                return "dk_driverdata_mysynthesis_speeding_score".dkDriverDataLocalized()
            case .none:
                return "-"
        }
    }
    
    public var currentScoreText: String {
        guard let scoreValue = scoreSynthesis?.scoreValue else {
            return "- "
            + DKCommonLocalizable.unitScore.text()
        }
        
        return scoreOutOfTenText(for: scoreValue)
    }
    
    public var currentScoreTextColor: DKUIColors {
        hasCurrentScore ? .primaryColor : .complementaryFontColor
    }
    
    public var evolutionText: NSAttributedString? {
        guard let localisationKeyPrefix = localisationKeyPrefixForEvolutionText else {
            return nil
        }
        
        guard
            let previousValue = scoreSynthesis?.previousScoreValue,
            hasCurrentScore ||
            hasOnlyShortTripsForCurrentPeriod
        else {
            return localisationKeyPrefix.dkDriverDataLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .smallText)
                .color(.complementaryFontColor)
                .build()
        }
        
        var evolutionTextPrefix = localisationKeyPrefix.dkDriverDataLocalized()
        if period == .year, let previousPeriodDate {
            let previousYear = DriveKitUI.calendar.component(.year, from: previousPeriodDate)
            evolutionTextPrefix = String(format: evolutionTextPrefix, String(previousYear))
        }
        
        return "%@ %@".dkAttributedString()
            .color(.complementaryFontColor)
            .buildWithArgs(
                evolutionTextPrefix
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .smallText
                    )
                    .build(),
                scoreOutOfTenText(for: previousValue)
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .headLine2
                    )
                    .build()
            )
    }
    
    public var currentTrendScoreImage: DKDriverDataImages {
        switch scoreSynthesis?.evolutionTrend {
            case .up:
                return .trendPositive
            case .down:
                return .trendNegative
            case .stable,
                .none:
                return .trendSteady
        }
    }
    
    public var currentTrendScoreImageColor: DKUIColors {
        switch scoreSynthesis?.evolutionTrend {
            case .up,
                .down,
                .stable:
                return .primaryColor
            case .none:
                return .complementaryFontColor
        }
    }
    
    public func configure(
        with scoreSynthesis: DKScoreSynthesis,
        period: DKPeriod,
        previousPeriodDate: Date?,
        hasOnlyShortTripsForPreviousPeriod: Bool,
        hasOnlyShortTripsForCurrentPeriod: Bool
    ) {
        self.scoreSynthesis = scoreSynthesis
        self.period = period
        self.previousPeriodDate = previousPeriodDate
        self.hasOnlyShortTripsForPreviousPeriod = hasOnlyShortTripsForPreviousPeriod
        self.hasOnlyShortTripsForCurrentPeriod = hasOnlyShortTripsForCurrentPeriod
        self.scoreCardViewModelDidUpdate?()
    }
    
    // MARK: - Private Helpers
    
    private var hasCurrentScore: Bool {
        self.scoreSynthesis?.scoreValue != nil
    }
    
    private var hasPreviousScore: Bool {
        self.scoreSynthesis?.previousScoreValue != nil
    }
    
    private var localisationKeySuffixForPeriod: String {
        switch period {
            case .week:
                return "week"
            case .month:
                return "month"
            case .year:
                return "year"
            case .none:
                return ""
        }
    }
    
    private var localisationKeyPrefixForEvolutionText: String? {
        enum TripKind {
            case noTrip, onlyShortTrips, scoredTrips
        }
        
        let previousPeriod: TripKind = hasPreviousScore
            ? .scoredTrips
            : hasOnlyShortTripsForPreviousPeriod
                ? .onlyShortTrips
                : .noTrip
        let currentPeriod: TripKind = hasCurrentScore
            ? .scoredTrips
            : hasOnlyShortTripsForCurrentPeriod
                ? .onlyShortTrips
                : .noTrip
        
        // No current score + only short trips = safety or ecodriving with no score while speeding and distraction have one
        // current score + only short trips = speeding and distraction with a score while safety or ecodriving have not
        // no current score + no trips at all = impossible
        switch (previousPeriod, currentPeriod) {
            case (.noTrip, .noTrip),
                (.onlyShortTrips, .onlyShortTrips),
                (.onlyShortTrips, .scoredTrips):
                return "dk_driverdata_mysynthesis_no_trip_at_all"
            case (.noTrip, .scoredTrips),
                (.noTrip, .onlyShortTrips):
                return "dk_driverdata_mysynthesis_no_trip_prev_" + localisationKeySuffixForPeriod
            case (.scoredTrips, .scoredTrips),
                (.scoredTrips, .onlyShortTrips):
                return "dk_driverdata_mysynthesis_previous_" + localisationKeySuffixForPeriod
            case (.scoredTrips, .noTrip),
                (.onlyShortTrips, .noTrip):
                assertionFailure("We can't have previous score but no current score and no trips at all")
                return nil
        }
    }
    
    private func scoreOutOfTenText(for scoreValue: Double) -> String {
        scoreValue.formatDouble(places: 1)
        + " "
        + DKCommonLocalizable.unitScore.text()
    }
}
