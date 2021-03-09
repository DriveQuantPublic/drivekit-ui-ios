//
//  SpeedingPageViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 08/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitCommonUI

class SpeedingPageViewModel {
    var scoreType: ScoreType = .speeding
    var trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    func getScore() -> Double {
        return self.scoreType.rawValue(trip: trip)
    }

    func getScoreTitle() -> String {
        return self.scoreType.stringValue()
    }
}
