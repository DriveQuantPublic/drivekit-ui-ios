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
    var type: RoadContextType = .emptyData {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        update()
    }

    private func update() {
        let titleKey: String
        let descriptionKey: String
        switch self.type {
            case .data:
                preconditionFailure("We should not display EmptyRoadContextView when we have data")
            case .emptyData:
                titleKey = "dk_timeline_road_context_title_empty_data"
                descriptionKey = "dk_timeline_road_context_description_empty_data"
            case .noData:
                titleKey = "dk_timeline_road_context_no_context_title"
                descriptionKey = "dk_timeline_road_context_no_context_description"
            case .noDataSafety:
                titleKey = "dk_timeline_road_context_title_no_data"
                descriptionKey = "dk_timeline_road_context_description_no_data_safety"
            case .noDataEcodriving:
                titleKey = "dk_timeline_road_context_title_no_data"
                descriptionKey = "dk_timeline_road_context_description_no_data_ecodriving"
        }
        self.titleLabel.text = titleKey.dkDriverDataTimelineLocalized()
        self.descriptionLabel.text = descriptionKey.dkDriverDataTimelineLocalized()
        self.titleLabel.textColor = DKUIColors.primaryColor.color
        self.descriptionLabel.textColor = DKUIColors.complementaryFontColor.color
    }
}
