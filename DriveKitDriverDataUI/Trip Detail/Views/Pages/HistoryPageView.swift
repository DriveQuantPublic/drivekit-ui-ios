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
        historyTimeLabel.attributedText = event.date.format(pattern: .hourMinuteLetter).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        
        topLine.isHidden = false
        bottomLine.isHidden = false
        topLine.backgroundColor = UIColor.dkMapTrace.withAlphaComponent(0.5)
        bottomLine.backgroundColor = UIColor.dkMapTrace.withAlphaComponent(0.5)
        
        if event.type == .start {
            topLine.isHidden = true
        } else if event.type == .end {
            bottomLine.isHidden = true
        }
        
        historyImage.image = event.type.getImage()
        historyImage.tintColor = DKUIColors.mainFontColor.color
        descriptionLabel.attributedText = event.getTitle().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
}

