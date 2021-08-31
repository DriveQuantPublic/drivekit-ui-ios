//
//  MoreTripsViewCell.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 30/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class MoreTripsViewCell : UICollectionViewCell, Nibable {

    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.label.attributedText = DKCommonLocalizable.seeMoreTrips.text().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.complementaryFontColor).build()
    }

}
