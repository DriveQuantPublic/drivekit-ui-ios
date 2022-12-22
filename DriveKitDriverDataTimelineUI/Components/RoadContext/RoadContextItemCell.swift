//
//  RoadContextItemCell.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Amine Gahbiche on 26/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class RoadContextItemCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.complementaryFontColor.color
    }

    func update(title: String, color: UIColor) {
        self.titleLabel.text = title
        self.circleView.backgroundColor = color
    }
}
