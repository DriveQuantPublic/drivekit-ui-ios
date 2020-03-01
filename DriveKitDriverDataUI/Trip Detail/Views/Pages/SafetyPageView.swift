//
//  SafetyPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class SafetyPageView : UIView, Nibable {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, image: String, count: Int) {
        DriverDataStyle.applyTripDarkGrey(label: eventTitle)
        eventTitle.text = title
        eventImage.image = UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        eventImage.tintColor = .black
        eventCount.attributedText = String(count).dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 16, traits: .traitBold)).color(.primaryColor).build()
    }
}
