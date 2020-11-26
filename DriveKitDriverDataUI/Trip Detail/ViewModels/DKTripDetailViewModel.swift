//
//  DKTripDetailViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 26/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKTripDetailViewModel {
    func setSelectedEvent(position: Int?)
    func getTripEvents() -> [TripEvent]
}
