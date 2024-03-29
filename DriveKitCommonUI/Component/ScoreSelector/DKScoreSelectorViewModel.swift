//
//  DKScoreSelectorViewModel.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 17/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

public class DKScoreSelectorViewModel {
    private let minimumScoreCountRequiredToDisplayScoreSelector = 2
    public weak var delegate: DKScoreSelectorDelegate?
    private var internalScores: [DKScoreType] = [.safety, .ecoDriving, .distraction, .speeding]
    public var scores: [DKScoreType] {
        get {
            self.internalScores.filter { score in
                score.hasAccess()
            }
        }
        set {
            self.internalScores = newValue
            self.selectedScore = self.internalScores.first ?? .safety
        }
    }
    public private(set) var selectedScore: DKScoreType = .safety
    var shouldHideScoreSelectorView: Bool {
        self.scores.count < minimumScoreCountRequiredToDisplayScoreSelector
    }
    
    public init() {
        self.selectedScore = self.scores.first ?? .safety
    }
    
    func didSelectScore(_ score: DKScoreType) {
        if self.selectedScore != score {
            self.selectedScore = score
            self.delegate?.scoreSelectorDidSelectScore(score)
        }
    }
}
