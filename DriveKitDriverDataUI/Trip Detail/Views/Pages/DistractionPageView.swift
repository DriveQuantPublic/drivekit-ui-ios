//
//  DistractionPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//
import UIKit

final class DistractionPageView : UIView, Nibable {
    
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, count: NSAttributedString) {
        DriverDataStyle.applyTripDarkGrey(label: eventTitle)
        eventTitle.text = title
        eventCount.attributedText = count
    }
    
}

