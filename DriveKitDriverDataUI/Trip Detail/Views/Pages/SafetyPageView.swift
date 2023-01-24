// swiftlint:disable all
//
//  SafetyPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class SafetyPageView: UIView, Nibable {
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventCount: UILabel!

    func configure(title: String, image: UIImage?, count: Int) {
        eventTitle.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        eventImage.image = image
        eventImage.tintColor = DKUIColors.mainFontColor.color
        eventCount.attributedText = String(count).dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.primaryColor).build()
    }
}
