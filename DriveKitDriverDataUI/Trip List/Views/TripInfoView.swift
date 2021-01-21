//
//  AdviceCountView.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

final class TripInfoView: UIView, Nibable {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var image: UIImageView!

    var trip: Trip? = nil
    var tripInfo: DKTripInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setText(_ text: String, style: DKStyle) {
        self.text.attributedText = text.dkAttributedString().font(dkFont: .primary, style: style).color(.fontColorOnSecondaryColor).build()
    }

    func setTrip(trip: Trip) {
        self.trip = trip
    }

}
