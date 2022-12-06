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

    func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.descriptionLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        self.titleLabel.text = "dk_timeline_road_context_title_empty_data".dkDriverDataTimelineLocalized()
        self.descriptionLabel.text = "dk_timeline_road_context_description_empty_data".dkDriverDataTimelineLocalized()
    }
}
