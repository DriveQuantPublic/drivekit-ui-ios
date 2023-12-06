//
//  MoreTripsViewCell.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 30/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

final class MoreTripsViewCell: UICollectionViewCell, Nibable {

    @IBOutlet private weak var label: UILabel!
    var hasMoreTrips: Bool = true {
        didSet {
            updateLabel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        updateLabel()
    }

    private func updateLabel() {
        let textKey: DKCommonLocalizable
        if self.hasMoreTrips {
            textKey = DKCommonLocalizable.seeMoreTrips
        } else {
            textKey = DKCommonLocalizable.noTripsYet
        }
        self.label.attributedText = textKey.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }

}
