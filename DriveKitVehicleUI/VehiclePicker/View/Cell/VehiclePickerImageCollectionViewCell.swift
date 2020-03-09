//
//  VehiclePickerCollectionViewCell.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconTitle: UILabel!
    
    func configure(image: UIImage?, text: String?, showLabel : Bool) {
        self.iconImageView.image = image
        if showLabel {
            self.iconTitle.isHidden = false
            self.iconTitle.attributedText = text?.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        } else {
            self.iconTitle.isHidden = true
        }
    }
}
