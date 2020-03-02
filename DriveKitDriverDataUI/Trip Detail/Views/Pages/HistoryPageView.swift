//
//  HistoryPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class HistoryPageView : UITableViewCell, Nibable {
    
    @IBOutlet var historyTimeLabel: UILabel!
    @IBOutlet var topLine: UIView!
    @IBOutlet var historyImage: UIImageView!
    @IBOutlet var bottomLine: UIView!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView()
        self.selectionStyle = .default
    }
    
    func configure(event: TripEvent) {
        DriverDataStyle.applyTripHour(label: historyTimeLabel)
        historyTimeLabel.text = event.date.format(pattern: .hourMinute)
        
        topLine.isHidden = false
        bottomLine.isHidden = false
        topLine.backgroundColor = UIColor.dkMapTrace.withAlphaComponent(0.5)
        bottomLine.backgroundColor = UIColor.dkMapTrace.withAlphaComponent(0.5)
        
        if event.type == .start {
            topLine.isHidden = true
        } else if event.type == .end {
            bottomLine.isHidden = true
        }
        
        let image = UIImage(named: event.type.getImageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)
        historyImage.image = image
        historyImage.tintColor = .black
        DriverDataStyle.applyTripDarkGrey(label: descriptionLabel)
        descriptionLabel.text = event.type.name()
    }
}

