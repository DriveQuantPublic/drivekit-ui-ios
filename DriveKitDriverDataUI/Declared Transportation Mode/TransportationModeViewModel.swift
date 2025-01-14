// swiftlint:disable all
//
//  TransportationModeViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 09/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class TransportationModeViewModel {
    private let trip: DKTrip
    var selectedTransportationMode: TransportationMode?
    
    init(trip: DKTrip) {
        self.trip = trip
        self.selectedTransportationMode = self.declaredTransportationMode()
    }
    
    var comment: String? {
        return trip.declaredTransportationMode?.comment
    }
    
    var isPassenger: Bool? {
        return trip.declaredTransportationMode?.passenger
    }
    
    var itinId: String? {
        return trip.itinId
    }
    
    func declaredTransportationMode() -> TransportationMode? {
        return trip.declaredTransportationMode?.transportationMode
    }
}
