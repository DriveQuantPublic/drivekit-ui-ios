//
//  DistractionPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//
import UIKit
import DriveKitCommonUI

final class DistractionPageView : UIView, Nibable {

    var selected: Bool = false {
        didSet {
            if selected {
                self.eventValue.backgroundColor = DKUIColors.secondaryColor.color.withAlphaComponent(0.4)
                self.eventDescription.textColor = DKUIColors.secondaryColor.color
            } else {
                self.eventValue.backgroundColor = DKUIColors.neutralColor.color
                self.eventDescription.textColor = grayColor
            }
        }
    }
    @IBOutlet private var eventTitle: UILabel!
    @IBOutlet private var eventValue: UILabel!
    @IBOutlet private var eventDescription: UILabel!
    @IBOutlet private var separator: UIView!
    private let grayColor = UIColor(hex:0x9e9e9e)

    override func awakeFromNib() {
        super.awakeFromNib()

        // Title.
        self.eventTitle.textColor = DKUIColors.mainFontColor.color
        self.eventTitle.font = DKStyles.highlightSmall.style.applyTo(font: .primary)
        // Value.
        self.eventValue.font = DKStyles.highlightNormal.style.applyTo(font: .primary)
        self.eventValue.textColor = DKUIColors.primaryColor.color
        self.eventValue.layer.borderWidth = 1
        self.eventValue.layer.borderColor = grayColor.cgColor
        self.eventValue.layer.masksToBounds = true
        // Description.
        self.eventDescription.textColor = grayColor
        self.eventDescription.font = DKStyles.smallText.style.applyTo(font: .primary)
        // Separator.
        self.separator.backgroundColor = DKUIColors.neutralColor.color

        self.selected = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.eventValue.layer.cornerRadius = self.eventValue.bounds.size.height / 2
        updateTextIntrinsicContentSize()
    }
    
    func configure(title: String, description: String, value: String) {
        self.eventTitle.text = title
        self.eventDescription.text = description
        self.eventValue.text = value
        updateTextIntrinsicContentSize()
    }

    private func updateTextIntrinsicContentSize() {
        self.eventTitle.invalidateIntrinsicContentSize()
        self.eventDescription.invalidateIntrinsicContentSize()
    }
    
}

