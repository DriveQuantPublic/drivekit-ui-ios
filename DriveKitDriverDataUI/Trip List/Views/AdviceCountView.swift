//
//  AdviceCountView.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess
import DriveKitCommonUI

final class AdviceCountView: UIView, Nibable  {

    @IBOutlet weak var adviceCountLabel: UILabel!
    
    var trip: Trip? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAdviceCount(count: String){
        adviceCountLabel.attributedText = count.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.fontColorOnSecondaryColor).build()
    }
    
    func setTrip(trip: Trip) {
        self.trip = trip
    }

}
