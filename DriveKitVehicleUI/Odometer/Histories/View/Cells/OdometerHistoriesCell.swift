//
//  OdometerHistoriesCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class OdometerHistoriesCell: UITableViewCell, Nibable {
    @IBOutlet private weak var referenceImage: UIImageView!
    @IBOutlet private weak var referenceLabel: UILabel!
    @IBOutlet private weak var referenceDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    func configure() {
        self.referenceImage.image = DKImages.ecoAccel.image?.withRenderingMode(.alwaysTemplate)
        self.referenceImage.tintColor = DKUIColors.complementaryFontColor.color
    }

    func update(distance: Double, date: Date) {
        self.referenceLabel.attributedText = distance.formatKilometerDistance().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.complementaryFontColor).build()
        self.referenceDate.attributedText = date.format(pattern: .fullDate).capitalizeFirstLetter().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
    }
}
