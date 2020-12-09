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
    
    private let trip: Trip
    var selectedTransportationMode: TransportationMode? = nil
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    var comment: String? {
        return trip.declaredTransportationMode?.comment
    }
    
    var isDriver: Bool? {
        return trip.declaredTransportationMode?.passenger
    }
    
    var itinId: String? {
        return trip.itinId
    }
    
    func declaredTransportationMode() -> TransportationMode? {
        if let declaredTransportation = trip.declaredTransportationMode?.transportationMode {
            return TransportationMode(rawValue: Int(declaredTransportation))
        } else {
            return nil
        }
    }
}
