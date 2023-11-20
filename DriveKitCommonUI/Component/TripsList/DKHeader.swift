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
    func customTripListHeader(trips: [DKTripListItem]) -> String?
    func customTripDetailHeader(trip: DKTripListItem) -> String?
}

public extension DKHeader {
    func tripListHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func tripDetailHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func customTripListHeader(trips: [DKTripListItem]) -> String? {
        return nil
    }
    
    func customTripDetailHeader(trip: DKTripListItem) -> String? {
        return nil
    }
    
}
