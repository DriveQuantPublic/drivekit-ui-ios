//
//  HeaderDayView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 07/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class HeaderDayView: UIView, Nibable {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(trips: TripsByDate) {
        var rightText = ""
        if let dkHeader = DriveKitDriverDataUI.shared.customHeader {
            if let text = dkHeader.customTripListheader(trips: trips.trips) {
                rightText = text
            } else {
                rightText = dkHeader.tripListHeader().text(trips: trips.trips)
            }
        } else {
            rightText = DriveKitDriverDataUI.shared.headerDay.text(trips: trips.trips)
        }
        self.setupAsHeader(leftText: trips.date.format(pattern: .weekLetter), rightText: rightText, isRounded: true)
    }
    
    func setupAsHeader(leftText: String, rightText: String, isRounded: Bool = false) {
        self.backgroundView.backgroundColor = DKUIColors.neutralColor.color
        if isRounded {
            self.backgroundView.backgroundColor = DKUIColors.neutralColor.color
            self.rightLabel.attributedText = rightText.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            self.leftLabel.attributedText = leftText.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            self.backgroundView.layer.cornerRadius = 4
            self.backgroundView.layer.masksToBounds = true
        } else {
            self.backgroundView.backgroundColor = DKUIColors.primaryColor.color
            self.rightLabel.attributedText = rightText.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.fontColorOnPrimaryColor).build()
            self.leftLabel.attributedText = leftText.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.fontColorOnPrimaryColor).build()
            self.backgroundColor = DKUIColors.primaryColor.color
        }
    }
}

