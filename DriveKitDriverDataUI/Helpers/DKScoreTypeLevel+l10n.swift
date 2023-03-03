//
//  DKScoreTypeLevel+l10n.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 03/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import Foundation

extension DKScoreTypeLevel {
    public func localizedTitle(for scoreType: DKScoreType) -> String {
        let scoreLevelRange = self.scoreLevels(for: scoreType)
        return String(
            format: localizedTitleKey.dkDriverDataLocalized(),
            scoreLevelRange.lowerBound.formatDouble(places: 1),
            scoreLevelRange.upperBound.formatDouble(places: 1)
        )
    }
    
    public func localizedDescription(for scoreType: DKScoreType) -> String {
        localizedDescriptionKey(for: scoreType).dkDriverDataLocalized()
    }
    
    private var localizedTitleKey: String {
        "dk_driverdata_mysynthesis_score_title_" + self.localizedScoreLevelKeySuffix
    }
    
    private func localizedDescriptionKey(for scoreType: DKScoreType) -> String {
        "dk_driverdata_mysynthesis_\(scoreType.localizedScoreTypeKeySuffix)_level_\(self.localizedScoreLevelKeySuffix)"
    }
    
    private var localizedScoreLevelKeySuffix: String {
        switch self {
            case .veryBad:
                return "excellent"
            case .bad:
                return "bad"
            case .notGood:
                return "low"
            case .medium:
                return "average"
            case .great:
                return "good"
            case .veryGood:
                return "very_good"
            case .excellent:
                return "excellent"
        }
    }
}

extension DKScoreType {
    var localizedScoreTypeKeySuffix: String {
        switch self {
            case .safety:
                return "safety"
            case .ecoDriving:
                return "ecodriving"
            case .distraction:
                return "distraction"
            case .speeding:
                return "speeding"
        }
    }
}
