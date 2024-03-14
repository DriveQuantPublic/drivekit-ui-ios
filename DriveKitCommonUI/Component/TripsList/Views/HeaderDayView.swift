//
//  HeaderDayView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 07/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public final class HeaderDayView: UIView, Nibable {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    public func configure<TripsListItem: DKTripListItem> (trips: [TripsListItem], date: Date, headerDay: HeaderDay, dkHeader: DKHeader?) {
        var rightText = ""
        if let dkHeader = dkHeader {
            if let text = dkHeader.customTripListHeader(trips: trips) {
                rightText = text
            } else {
                rightText = dkHeader.tripListHeader().text(trips: trips)
            }
        } else {
            rightText = headerDay.text(trips: trips)
        }
        self.setupAsHeader(leftText: date.format(pattern: .weekLetter).capitalizeFirstLetter(), rightText: rightText, isRounded: true)
    }
    
    public func setupAsHeader(leftText: String, rightText: String, isRounded: Bool = false) {
        self.backgroundView.backgroundColor = DKUIColors.neutralColor.color
        if isRounded {
            self.backgroundView.backgroundColor = DKUIColors.neutralColor.color
            self.rightLabel.attributedText = rightText.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
            self.leftLabel.attributedText = leftText.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
            self.backgroundView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
            self.backgroundView.layer.masksToBounds = true
        } else {
            self.backgroundView.backgroundColor = DKUIColors.primaryColor.color
            self.rightLabel.attributedText = rightText.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.fontColorOnPrimaryColor).build()
            self.leftLabel.attributedText = leftText.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.fontColorOnPrimaryColor).build()
            self.backgroundColor = DKUIColors.primaryColor.color
        }
    }
}
