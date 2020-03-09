//
//  VehiclePickerLabelCollectionViewCell.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    func configure(text: String) {
        self.textLabel.attributedText = text.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        
    }

}
