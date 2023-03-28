//
//  ScoreLevelLegendRowViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 03/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

public class ScoreLevelLegendRowViewModel {
    public var scoreType: DKScoreType?
    public var scoreTypeLevel: DKScoreTypeLevel?
    var scoreLevelLegendRowViewModelDidUpdate: (() -> Void)?
    
    public init() {}
    
    public var scoreLevelColor: UIColor {
        scoreTypeLevel?.color ?? .clear
    }
    
    public var scoreLevelDescription: NSAttributedString? {
        guard let scoreType, let scoreTypeLevel else { return nil }
        return "%@ %@".dkAttributedString()
            .buildWithArgs(
                scoreTypeLevel.localizedTitle(for: scoreType)
                    .dkAttributedString()
                    .font(
                        dkFont: .primary,
                        style: .normalText
                    )
                    .color(.mainFontColor)
                    .build(),
                scoreTypeLevel.localizedDescription(for: scoreType)
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
        with scoreType: DKScoreType,
        scoreTypeLevel: DKScoreTypeLevel
    ) {
        self.scoreType = scoreType
        self.scoreTypeLevel = scoreTypeLevel
        self.scoreLevelLegendRowViewModelDidUpdate?()
    }
}
