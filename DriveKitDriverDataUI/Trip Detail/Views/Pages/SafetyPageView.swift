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
    
    func configure(title: String, image: UIImage?, count: Int) {
        eventTitle.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        eventImage.image = image
        eventImage.tintColor = DKUIColors.mainFontColor.color
        eventCount.attributedText = String(count).dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
    }
}
