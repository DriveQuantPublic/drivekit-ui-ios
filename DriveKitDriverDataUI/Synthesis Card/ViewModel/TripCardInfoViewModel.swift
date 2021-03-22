//
//  TripCardInfoViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule

class TripCardInfoViewModel {
    private let tripCardInfo: DKTripCardInfo
    private let trips: [Trip]

    init(tripCardInfo: DKTripCardInfo, trips: [Trip]) {
        self.tripCardInfo = tripCardInfo
        self.trips = trips
    }

    func getIcon() -> UIImage? {
        self.tripCardInfo.getIcon()
    }

    func getText() -> NSAttributedString {
        self.tripCardInfo.getText(trips: self.trips)
    }
}
