//
//  AdviceButton.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 31/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess

class AdviceButton: UIButton {

    let trip: Trip

    
    init(frame: CGRect, trip: Trip) {
        self.trip = trip
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
