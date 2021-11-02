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

    private var odometerHistoriesCellViewModel: OdometerHistoriesCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    func update(odometerHistoriesCellViewModel: OdometerHistoriesCellViewModel) {
        self.referenceLabel.attributedText = odometerHistoriesCellViewModel.getDistance().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
        self.referenceDate.attributedText = odometerHistoriesCellViewModel.getDate().dkAttributedString().font(dkFont: .primary, style: .smallText).color(UIColor(hex: 0x9e9e9e)).build()
    }

    private func configure() {
        self.referenceImage.image = DKImages.ecoAccel.image?.withRenderingMode(.alwaysTemplate)
        self.referenceImage.tintColor = DKUIColors.mainFontColor.color
    }
}
