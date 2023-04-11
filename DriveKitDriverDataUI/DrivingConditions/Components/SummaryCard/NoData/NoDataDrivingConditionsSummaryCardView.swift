//
//  NoDataDrivingConditionsSummaryCardView.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 11/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class NoDataDrivingConditionsSummaryCardView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.primaryColor.color
        self.descriptionLabel.textColor = DKUIColors.complementaryFontColor.color
    }
    
    func configure(withTitle title: String?, description: String?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
