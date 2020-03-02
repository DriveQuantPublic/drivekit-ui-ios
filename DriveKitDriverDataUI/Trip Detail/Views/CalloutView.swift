//
//  CalloutView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 17/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class CalloutView: UIView, Nibable {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()    }
    
    func configure(viewModel: TripEventCalloutViewModel) {
        DriverDataStyle.applyTripHour(label: timeLabel)
        timeLabel.text = viewModel.time
        titleLabel.attributedText = viewModel.title.dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 16, traits: .traitBold)).color(.primaryColor).build()
        
        if viewModel.event.type == .start || viewModel.event.type == .end {
            subtitleLabel.font = subtitleLabel.font.withSize(14)
            subtitleLabel.textColor = .black
        } else {
            subtitleLabel.font = subtitleLabel.font.withSize(14)
            subtitleLabel.textColor = DKUIColors.primaryColor.color
        }
        subtitleLabel.attributedText = viewModel.subtitle
    }
}
