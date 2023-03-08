//
//  ScoreLevelLegendViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 03/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import DriveKitCommonUI
import Foundation

public class ScoreLevelLegendViewModel {
    public var scoreType: DKScoreType?
    public var scoreLevelRowViewModels: [ScoreLevelLegendRowViewModel]?
    
    public init() {}
    
    public var legendTitle: String? {
        guard let scoreType else { return nil }
        return "dk_driverdata_\(scoreType.scoreTypeKeySuffix)_score".dkDriverDataLocalized()
    }
    
    public var legendDescription: String? {
        guard let scoreType else { return nil }
        return "dk_driverdata_mysynthesis_\(scoreType.scoreTypeKeySuffix)_score_info".dkDriverDataLocalized()
    }
    
    public func configure(
        with scoreType: DKScoreType
    ) {
        self.scoreType = scoreType
        scoreLevelRowViewModels = DKScoreTypeLevel.allCases.reversed().map { scoreTypeLevel in
            let viewModel = ScoreLevelLegendRowViewModel()
            viewModel.configure(with: scoreType, scoreTypeLevel: scoreTypeLevel)
            return viewModel
        }
    }
}
