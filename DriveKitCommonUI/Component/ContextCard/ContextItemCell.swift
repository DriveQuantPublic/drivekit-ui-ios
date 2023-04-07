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
    @IBOutlet private weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(title: String, subtitle: String? = nil, color: UIColor) {
        self.circleView.backgroundColor = color
        self.titleLabel.attributedText = getTitleAttributedString(title: title, subtitle: subtitle)
    }

    private func getTitleAttributedString(title: String, subtitle: String? = nil) -> NSMutableAttributedString {
        if let subtitle = subtitle {
            let subtitleString = subtitle.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
            let titleString = title.appending("\n").dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).buildWithArgs(subtitleString)
            return titleString
        } else {
            return title.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        }
    }
}
