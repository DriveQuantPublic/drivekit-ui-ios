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
    var type: EmptyRoadContextType = .emptyData {
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
        self.descriptionLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        update()
    }

    private func update() {
        let titleKey: String
        let descriptionKey: String
        switch self.type {
            case .emptyData:
                titleKey = "dk_timeline_road_context_title_empty_data"
                descriptionKey = "dk_timeline_road_context_description_empty_data"
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

enum EmptyRoadContextType {
    case emptyData
    case noDataSafety
    case noDataEcodriving
}
