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
    
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, count: NSAttributedString) {
        eventTitle.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        eventCount.attributedText = count
    }
    
}

