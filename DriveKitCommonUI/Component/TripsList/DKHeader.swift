//
//  DKHeader.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 26/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKHeader {
    func tripListHeader() -> HeaderDay
    func tripDetailHeader() -> HeaderDay
    func customTripListHeader(trips: [DKTripsListItem]) -> String?
    func customTripDetailHeader(trip: DKTripsListItem) -> String?
}

public extension DKHeader {
    func tripListHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func tripDetailHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func customTripListHeader(trips: [DKTripsListItem]) -> String? {
        return nil
    }
    
    func customTripDetailHeader(trip: DKTripsListItem) -> String? {
        return nil
    }
    
}
