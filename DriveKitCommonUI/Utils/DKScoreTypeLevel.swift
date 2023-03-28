//
//  DKScoreTypeLevel.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 02/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import UIKit

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
    
    public func scoreLevels(for scoreType: DKScoreType) -> any BoundedRangeExpression<Double> {
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

    public static func getLevel(for score: Double, scoreType: DKScoreType) -> DKScoreTypeLevel {
        guard
            let level = Self.allCases.filter({
                $0.scoreLevels(for: scoreType).contains(score)
            }).first
        else {
            if score < Self.veryBad.scoreLevels(for: scoreType).lowerBound {
                return .veryBad
            } else {
                return .excellent
            }
        }
        return level
    }
}

public protocol BoundedRangeExpression<Bound>: RangeExpression {
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
}

extension Range: BoundedRangeExpression {}
extension ClosedRange: BoundedRangeExpression {}
