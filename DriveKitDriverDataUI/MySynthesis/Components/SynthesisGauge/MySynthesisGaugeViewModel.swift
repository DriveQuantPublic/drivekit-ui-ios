//
//  MySynthesisGaugeViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

class MySynthesisGaugeViewModel {
    private(set) var scoreType: DKScoreType = .safety
    private(set) var mean: Double = 0
    private(set) var min: Double = 0
    private(set) var max: Double = 0
    private(set) var median: Double = 0
    private var score: Double?
    private(set) var buttonTitle: String = ""

    var hasScore: Bool {
        return score != nil
    }

    // swiftlint:disable:next function_parameter_count
    func configure(scoreType: DKScoreType, mean: Double, median: Double, min: Double, max: Double, score: Double?) {
        self.scoreType = scoreType
        self.mean = mean
        self.median = median
        self.min = min
        self.max = max
        self.score = score
        if let score {
            self.buttonTitle = DKScoreTypeLevel.getLevel(for: score, scoreType: scoreType).localizedShortDescription()
        }
    }

    func getBarItemsToDraw() -> [DKRoundedBarViewItem] {
        var barViewItems: [DKRoundedBarViewItem] = []
        let fullScoreLevelRange = DKScoreTypeLevel.fullScoreLevelRange(for: scoreType)
        let max = fullScoreLevelRange.upperBound
        let min = fullScoreLevelRange.lowerBound
        for scoreLevel in DKScoreTypeLevel.allCases {
            let levelRange = scoreLevel.scoreLevels(for: scoreType)
            let percent = (levelRange.upperBound - levelRange.lowerBound) / (max - min)
            let color = scoreLevel.color
            barViewItems.append(DKRoundedBarViewItem(percent: percent, color: color))
        }
        return barViewItems
    }

    func offsetPercent(forScore  score: Double, gaugeWidth: Double = 1) -> Double {
        let fullScoreLevelRange = DKScoreTypeLevel.fullScoreLevelRange(for: scoreType)
        let max = fullScoreLevelRange.upperBound
        let min = fullScoreLevelRange.lowerBound

        let offset = gaugeWidth * (score - min) / (max - min)
        return offset
    }

    var meanOffsetPercent: Double {
        offsetPercent(forScore: mean)
    }

    var medianOffsetPercent: Double {
        offsetPercent(forScore: median)
    }

    var scoreOffsetPercent: Double {
        offsetPercent(forScore: score ?? 0)
    }

    var minOffsetPercent: Double {
        offsetPercent(forScore: min)
    }

    var maxOffsetPercent: Double {
        offsetPercent(forScore: max)
    }

    func offsetPercent(forStep index: Int) -> Double {
        let stepScore = scoreForStep(index)
        return offsetPercent(forScore: stepScore)
    }

    func scoreForStep(_ index: Int) -> Double {
        let steps = self.scoreType.getSteps()

        guard steps.count > index else {
            return 0
        }
        return steps[index]
    }

    func offsetForButton(gaugeWidth: Double, itemWidth: Double, margin: Double) -> Double {
        var offset = offsetPercent(forScore: score ?? 0, gaugeWidth: gaugeWidth)
        // swiftlint:disable no_magic_numbers
        if offset < itemWidth / 2 - margin {
            offset = itemWidth / 2 - margin
        } else if offset > gaugeWidth + margin - itemWidth / 2 {
            offset = gaugeWidth + margin - itemWidth / 2
        }
        // swiftlint:enable no_magic_numbers
        return offset
    }
}

extension DKScoreTypeLevel {
    public static func fullScoreLevelRange(for scoreType: DKScoreType) -> ClosedRange<Double> {
        let max = DKScoreTypeLevel.excellent.scoreLevels(for: scoreType).upperBound
        let min = DKScoreTypeLevel.veryBad.scoreLevels(for: scoreType).lowerBound
        return min...max
    }
}
