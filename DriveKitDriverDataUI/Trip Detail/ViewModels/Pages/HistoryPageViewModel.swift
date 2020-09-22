//
//  HistoryPageViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverDataModule
import CoreLocation

class HistoryPageViewModel {
    let events: [TripEvent]
    let tripDetailViewModel : TripDetailViewModel
    
    init(events: [TripEvent], tripDetailViewModel: TripDetailViewModel) {
        self.events = events
        self.tripDetailViewModel = tripDetailViewModel
    }
}
