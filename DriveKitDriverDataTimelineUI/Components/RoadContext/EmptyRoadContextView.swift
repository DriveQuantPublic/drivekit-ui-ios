//
//  EmptyRoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Amine Gahbiche on 26/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class EmptyRoadContextView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(withTitle title: String, description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }

    private func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.primaryColor.color
        self.descriptionLabel.textColor = DKUIColors.complementaryFontColor.color

    }
}
