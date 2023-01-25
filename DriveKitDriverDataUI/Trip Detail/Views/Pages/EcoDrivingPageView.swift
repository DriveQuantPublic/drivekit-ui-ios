// swiftlint:disable all
//
//  EcoDrivingPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//
import UIKit
import DriveKitCommonUI

final class EcoDrivingPageView: UIView, Nibable {
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventTitle: UILabel!

    func configure(title: String, image: UIImage?) {
        eventTitle.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        eventImage.image = image
        eventImage.tintColor = DKUIColors.mainFontColor.color
    }
}
