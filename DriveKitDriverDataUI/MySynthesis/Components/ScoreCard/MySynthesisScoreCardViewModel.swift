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
    
    public var evolutionText: NSAttributedString {
        guard
            let period
        else {
            return "".dkAttributedString().build()
        }
        
        guard scoreSynthesis?.scoreValue != nil else {
            if hasNoScoredTripForSelectedPeriod {
                return "dk_driverdata_mysynthesis_not_enough_data".dkDriverDataLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .smallText)
                    .color(.complementaryFontColor)
                    .build()
            }
            
            let text: String
            switch period {
                case .week:
                    text = "dk_driverdata_mysynthesis_no_driving_week".dkDriverDataLocalized()
                case .month:
                    text = "dk_driverdata_mysynthesis_no_driving_month".dkDriverDataLocalized()
                case .year:
                    text = "dk_driverdata_mysynthesis_no_driving_year".dkDriverDataLocalized()
            }
            return text.dkAttributedString()
                .font(dkFont: .primary, style: .smallText)
                .color(.complementaryFontColor)
                .build()
        }

        guard
            let previousValue = scoreSynthesis?.previousScoreValue
        else {
            let text: String
            switch period {
                case .week:
                    text = "dk_driverdata_mysynthesis_no_trip_prev_week".dkDriverDataLocalized()
                case .month:
                    text = "dk_driverdata_mysynthesis_no_trip_prev_month".dkDriverDataLocalized()
                case .year:
                    text = "dk_driverdata_mysynthesis_no_trip_prev_year".dkDriverDataLocalized()
            }
            return text.dkAttributedString()
                .font(dkFont: .primary, style: .smallText)
                .color(.complementaryFontColor)
                .build()
        }

        let prefix: String
        switch period {
            case .week:
                prefix = "dk_driverdata_mysynthesis_previous_week".dkDriverDataLocalized()
            case .month:
                prefix = "dk_driverdata_mysynthesis_previous_month".dkDriverDataLocalized()
            case .year:
                prefix = "dk_driverdata_mysynthesis_previous_year".dkDriverDataLocalized()
        }
        return "%@ %@".dkAttributedString()
            .color(.complementaryFontColor)
            .buildWithArgs(
                prefix.dkAttributedString()
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
    
    public var currentTrendScoreImage: DKImages {
        switch scoreSynthesis?.evolutionTrend {
            case .up:
                return .trendPositive
            case .down:
                return .trendNegative
            case .same,
                .none:
                return .trendSteady
        }
    }
    
    public var currentTrendScoreImageColor: DKUIColors {
        switch scoreSynthesis?.evolutionTrend {
            case .up,
                .down,
                .same:
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
