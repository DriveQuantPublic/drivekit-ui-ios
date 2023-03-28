//
//  ScoreSelectionTypeView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 17/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import UIKit

class ScoreSelectionTypeView: UIControl {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectionIndicator: UIView!
    private(set) var scoreType: DKScoreType!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionIndicator.backgroundColor = DKUIColors.secondaryColor.color
    }

    func update(scoreType: DKScoreType) {
        self.scoreType = scoreType
        self.imageView.image = scoreType.scoreSelectorImage()
    }

    func setSelected(_ selected: Bool) {
        self.selectionIndicator.isHidden = !selected
    }
}

extension ScoreSelectionTypeView {
    static func createScoreSelectionButton(for score: DKScoreType, isSelected: Bool) -> ScoreSelectionTypeView? {
        guard let selectorView = Bundle.driveKitCommonUIBundle?.loadNibNamed("ScoreSelectionTypeView", owner: nil, options: nil)?.first as? ScoreSelectionTypeView else {
            assertionFailure("Can't find ScoreSelectionTypeView.xib file in CommonUI Bundle")
            return nil
        }
        
        selectorView.update(scoreType: score)
        selectorView.setSelected(isSelected)
        return selectorView
    }
}
