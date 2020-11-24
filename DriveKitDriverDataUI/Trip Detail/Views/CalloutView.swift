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
        timeLabel.attributedText = viewModel.time.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        titleLabel.attributedText = viewModel.title.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        subtitleLabel.attributedText = viewModel.subtitle
    }
}
