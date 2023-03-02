//
//  HorizontalGaugeViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

class HorizontalGaugeViewModel {
    private var scoreType: DKScoreType = .safety
    private(set) var mean: Double = 0
    private(set) var min: Double = 0
    private(set) var max: Double = 0
    private var score: Double = 0

    func configure(scoreType: DKScoreType, mean: Double, min: Double, max: Double, score: Double) {
        self.scoreType = scoreType
        self.mean = mean
        self.min = min
        self.max = max
        self.score = score
    }

    func getBarItemsToDraw() -> [DKCustomBarViewItem] {
        var barViewItems: [DKCustomBarViewItem] = []
        let steps = self.scoreType.getSteps()

        guard !steps.isEmpty else {
            return barViewItems
        }
        let max = steps.last!
        let min = steps.first!
        for i in 0..<steps.count - 1 {
            let percent = (steps[i + 1] - steps[i]) / (max - min)
            let color = ConfigurationCircularProgressView.getScoreColor(value: steps[i + 1], steps: steps)
            barViewItems.append(DKCustomBarViewItem(percent: percent, color: color))
        }
        return barViewItems
    }

    func offsetForScore(_ score: Double, gaugeWidth: Double = 1) -> Double {
        let steps = self.scoreType.getSteps()

        guard !steps.isEmpty else {
            return 0
        }
        let max = steps.last!
        let min = steps.first!

        let offset = gaugeWidth * (score - min) / (max - min)
        return offset
    }

    var meanOffsetPercent: Double {
        offsetForScore(mean)
    }

    var scoreOffsetPercent: Double {
        offsetForScore(score)
    }

    var minOffsetPercent: Double {
        offsetForScore(min)
    }

    var maxOffsetPercent: Double {
        offsetForScore(max)
    }
}
