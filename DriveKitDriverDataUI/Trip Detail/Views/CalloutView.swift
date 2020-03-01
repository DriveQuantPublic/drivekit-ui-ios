//
//  CalloutView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 17/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class CalloutView: UIView, Nibable {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()    }
    
    func configure(viewModel: TripEventCalloutViewModel) {        
        DriverDataStyle.applyTripHour(label: timeLabel)
        timeLabel.text = viewModel.time
        titleLabel.font = titleLabel.font.bold.withSize(16)
        
        titleLabel.textColor = config.primaryColor
        titleLabel.text = viewModel.title
        
        if viewModel.event.type == .start || viewModel.event.type == .end {
            subtitleLabel.font = subtitleLabel.font.withSize(14)
            subtitleLabel.textColor = .black
        } else {
            subtitleLabel.font = subtitleLabel.font.bold.withSize(14)
            subtitleLabel.textColor = config.primaryColor
        }
        subtitleLabel.attributedText = viewModel.subtitle
    }
}
