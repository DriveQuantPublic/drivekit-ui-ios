//
//  DKScoreTypeLevel.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 02/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

public enum DKScoreTypeLevel: CaseIterable {
    case veryBad
    case bad
    case notGood
    case medium
    case great
    case veryGood
    case excellent
    
    public var color: UIColor {
        switch self {
            case .veryBad:
                return .dkVeryBad
            case .bad:
                return .dkBad
            case .notGood:
                return .dkBadMean
            case .medium:
                return .dkMean
            case .great:
                return .dkGoodMean
            case .veryGood:
                return .dkGood
            case .excellent:
                return .dkExcellent
        }
    }
    
    public func scoreLevels(for scoreType: DKScoreType) -> any RangeExpression<Double> {
        let steps = scoreType.getSteps()
        // swiftlint:disable no_magic_numbers
        switch self {
            case .veryBad:
                return steps[0]..<steps[1]
            case .bad:
                return steps[1]..<steps[2]
            case .notGood:
                return steps[2]..<steps[3]
            case .medium:
                return steps[3]..<steps[4]
            case .great:
                return steps[4]..<steps[5]
            case .veryGood:
                return steps[5]..<steps[6]
            case .excellent:
                return steps[6]...steps[7]
        }
        // swiftlint:enable no_magic_numbers
    }
    
    public var localizedName: String {
        switch self {
            case .veryBad:
                return "dk_driverdata_mysynthesis_score_title_excellent"
            case .bad:
                return "dk_driverdata_mysynthesis_score_title_bad"
            case .notGood:
                return "dk_driverdata_mysynthesis_score_title_low"
            case .medium:
                return "dk_driverdata_mysynthesis_score_title_average"
            case .great:
                return "dk_driverdata_mysynthesis_score_title_good"
            case .veryGood:
                return "dk_driverdata_mysynthesis_score_title_very_good"
            case .excellent:
                return "dk_driverdata_mysynthesis_score_title_excellent"
        }
    }
}
