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
    public var scoreLevels: [DKScoreTypeLevel] = DKScoreTypeLevel.allCases
    
    public init() {}
    
    public func scoreLevelColor(for scoreLevel: DKScoreTypeLevel) -> UIColor {
        scoreLevel.color
    }
    
    public func scoreLevelDescription(
        for scoreLevel: DKScoreTypeLevel
    ) -> NSAttributedString? {
        guard let scoreType else { return nil }
        return "%@ %@".dkAttributedString()
            .buildWithArgs(
                scoreLevel.localizedTitle(for: scoreType)
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .headLine2
                    )
                    .color(.primaryColor)
                    .build(),
                scoreLevel.localizedDescription(for: scoreType)
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .smallText
                    )
                    .color(.complementaryFontColor)
                    .build()
            )
    }
    
    public func configure(
        with scoreType: DKScoreType
    ) {
        self.scoreType = scoreType
    }
}
