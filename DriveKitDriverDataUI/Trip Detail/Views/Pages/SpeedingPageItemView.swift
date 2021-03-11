//
//  SpeedingPageItemView.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 11/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class SpeedingPageItemView: UIView, Nibable {

    @IBOutlet private var eventTitle: UILabel!
    @IBOutlet private var eventValue: UILabel!
    @IBOutlet private var eventDescription: UILabel!
    @IBOutlet private var separator: UIView!
    @IBOutlet private var percentageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var percentageViewMarginConstraint: NSLayoutConstraint!

    private let grayColor = UIColor(hex:0x9e9e9e)

    override func awakeFromNib() {
        super.awakeFromNib()

        // Title.
        self.eventTitle.textColor = DKUIColors.mainFontColor.color
        self.eventTitle.font = DKStyles.highlightSmall.withSizeDelta(-1).applyTo(font: .primary)
        // Value.
        self.eventValue.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.eventValue.textColor = DKUIColors.primaryColor.color
        self.eventValue.layer.masksToBounds = true
        // Description.
        self.eventDescription.textColor = grayColor
        self.eventDescription.font = DKStyles.smallText.style.applyTo(font: .primary)
        // Separator.
        self.separator.backgroundColor = DKUIColors.neutralColor.color
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.eventValue.layer.cornerRadius = self.eventValue.bounds.size.height / 2
        self.eventValue.layer.borderWidth = 0.5
        self.eventValue.layer.borderColor = UIColor.black.cgColor
        updateTextIntrinsicContentSize()
    }

    func configure(title: String, description: String, value: String, displayValue: Bool) {
        self.eventTitle.text = title
        self.eventDescription.text = description
        self.eventValue.text = value
        if !displayValue {
            percentageViewWidthConstraint.constant = 0
            percentageViewMarginConstraint.constant = 0
            self.eventValue.isHidden = true
        }
        updateTextIntrinsicContentSize()
    }

    private func updateTextIntrinsicContentSize() {
        self.eventTitle.invalidateIntrinsicContentSize()
        self.eventDescription.invalidateIntrinsicContentSize()
    }
}
