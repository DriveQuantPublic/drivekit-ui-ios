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
    private var scoreSynthesis: DKScoreSynthesis?
    private var hasNoScoredTripForSelectedPeriod: Bool = false
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
        
        return scoreOnTenText(for: scoreValue)
    }
    
    public var currentScoreTextColor: DKUIColors {
        guard scoreSynthesis?.scoreValue != nil else {
            return .complementaryFontColor
        }
        
        return .primaryColor
    }
    
    public var evolutionText: NSAttributedString? {
        guard let localisationKeyPrefix = localisationKeyPrefixForEvolutionText else {
            return nil
        }
        
        guard
            let previousValue = scoreSynthesis?.previousScoreValue,
            scoreSynthesis?.scoreValue != nil
        else {
            return localisationKeyPrefix.dkDriverDataLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .smallText)
                .color(.complementaryFontColor)
                .build()
        }
        
        return "%@ %@".dkAttributedString()
            .color(.complementaryFontColor)
            .buildWithArgs(
                localisationKeyPrefix.dkDriverDataLocalized()
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .smallText
                    )
                    .build(),
                scoreOnTenText(for: previousValue)
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
    
    private func scoreOnTenText(for scoreValue: Double) -> String {
        scoreValue.formatDouble(places: 1)
            + " "
            + DKCommonLocalizable.unitScore.text()
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
        guard let scoreSynthesis else { return nil }
        let hasPreviousScore = (scoreSynthesis.previousScoreValue != nil)
        let hasCurrentScore = (scoreSynthesis.scoreValue != nil)
        let hasOnlyShortTrips = hasNoScoredTripForSelectedPeriod
        
        // No current score + only short trips = safety or ecodriving with no score while speeding and distraction have one
        // current score + only short trips = speeding and distraction with a score while safety or ecodriving have not
        // no current score + no trips at all = impossible
        switch (hasPreviousScore, hasCurrentScore, hasOnlyShortTrips) {
            case (false, false, _):
                return "dk_driverdata_mysynthesis_no_driving_" + localisationKeySuffixForPeriod
            case (false, true, _):
                return "dk_driverdata_mysynthesis_no_trip_prev_" + localisationKeySuffixForPeriod
            case (true, true, _):
                return "dk_driverdata_mysynthesis_previous_" + localisationKeySuffixForPeriod
            case (_, false, true):
                return "dk_driverdata_mysynthesis_not_enough_data"
            case (true, false, false):
                assertionFailure("We can't have previous score but no current score and no trips at all")
                return nil
        }
    }
    
    public func configure(
        with scoreSynthesis: DKScoreSynthesis,
        period: DKPeriod,
        hasNoScoredTripForSelectedPeriod: Bool
    ) {
        self.scoreSynthesis = scoreSynthesis
        self.period = period
        self.hasNoScoredTripForSelectedPeriod = hasNoScoredTripForSelectedPeriod
        self.scoreCardViewModelDidUpdate?()
    }
}
