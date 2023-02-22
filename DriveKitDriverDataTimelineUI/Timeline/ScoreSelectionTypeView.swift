// swiftlint:disable all
//
//  ScoreSelectionTypeView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 17/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ScoreSelectionTypeView: UIControl {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var selectionIndicator: UIView!
    private(set) var scoreType: DKScoreType?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionIndicator.backgroundColor = DKUIColors.secondaryColor.color
    }

    func update(scoreType: DKScoreType) {
        self.scoreType = scoreType
        self.imageView.image = scoreType.timelineScoreSelectorImage()
    }

    func setSelected(_ selected: Bool) {
        self.selectionIndicator.isHidden = !selected
    }
}
