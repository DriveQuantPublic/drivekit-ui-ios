//
//  AdviceCountView.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class TripInfoView: UIView, Nibable {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var image: UIImageView!

    var trip: DKTripListItem?

    func setText(_ text: String, style: DKStyle) {
        self.text.attributedText = text.dkAttributedString().font(dkFont: .primary, style: style).color(.fontColorOnSecondaryColor).build()
    }

    func setTrip(trip: DKTripListItem) {
        self.trip = trip
    }

}
