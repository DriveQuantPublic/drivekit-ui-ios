//
//  DistractionPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//
import UIKit
import DriveKitCommonUI

final class DistractionPageView : UIControl, Nibable {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.eventValue.backgroundColor = DKUIColors.secondaryColor.color.withAlphaComponent(0.4)
                self.eventDescription.textColor = DKUIColors.secondaryColor.color
            } else {
                self.eventValue.backgroundColor = UIColor(hex:0xf3f3f3)
                self.eventDescription.textColor = DKUIColors.complementaryFontColor.color
            }
        }
    }
    @IBOutlet private var eventTitle: UILabel!
    @IBOutlet private var eventValue: UILabel!
    @IBOutlet private var eventDescription: UILabel!
    @IBOutlet private var separator: UIView!
    @IBOutlet private(set) var button: UIButton!
    private(set) var mapTrace: DKMapTraceType = .unlockScreen

    override func awakeFromNib() {
        super.awakeFromNib()

        // Title.
        self.eventTitle.textColor = DKUIColors.mainFontColor.color
        self.eventTitle.font = DKStyles.highlightSmall.withSizeDelta(-1).applyTo(font: .primary)
        // Value.
        self.eventValue.font = DKStyle(size: DKStyles.smallText.style.size, traits: UIFontDescriptor.SymbolicTraits.traitBold).applyTo(font: .primary)

        self.eventValue.textColor = DKUIColors.primaryColor.color
        self.eventValue.layer.masksToBounds = true
        // Description.
        self.eventDescription.textColor = DKUIColors.complementaryFontColor.color
        self.eventDescription.font = DKStyles.smallText.style.applyTo(font: .primary)
        // Separator.
        self.separator.backgroundColor = DKUIColors.neutralColor.color

        self.isSelected = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.eventValue.layer.cornerRadius = self.eventValue.bounds.size.height / 2
        updateTextIntrinsicContentSize()
    }
    
    func configure(title: String, description: String, value: String, mapTrace: DKMapTraceType) {
        self.eventTitle.text = title
        self.eventDescription.text = description
        self.eventValue.text = value
        self.mapTrace = mapTrace
        updateTextIntrinsicContentSize()
    }

    private func updateTextIntrinsicContentSize() {
        self.eventTitle.invalidateIntrinsicContentSize()
        self.eventDescription.invalidateIntrinsicContentSize()
    }
    
}

