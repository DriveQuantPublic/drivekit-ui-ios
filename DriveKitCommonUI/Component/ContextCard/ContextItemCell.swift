// swiftlint:disable all
//
//  RoadContextItemCell.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Amine Gahbiche on 26/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class ContextItemCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(with context: DKContextItem) {
        self.titleLabel.font = DKStyles.normalText.style.applyTo(font: .primary)

        if let subTitle = context.subtitle {
            self.titleLabel.textColor = DKUIColors.primaryColor.color
            self.subtitleLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
            self.subtitleLabel.textColor = DKUIColors.complementaryFontColor.color
            self.subtitleLabel.text = subTitle
        } else {
            self.titleLabel.textColor = DKUIColors.complementaryFontColor.color
            self.subtitleLabel?.removeFromSuperview()
        }
        
        self.circleView.backgroundColor = context.color
        self.titleLabel.text = context.title
    }
}
