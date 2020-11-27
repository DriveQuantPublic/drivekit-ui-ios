//
//  DKHeader.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 26/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

public protocol DKHeader {
    func tripListHeader() -> HeaderDay
    func tripDetailHeader() -> HeaderDay
    func customTripListHeader(trips: [Trip]) -> String?
    func customTripDetailHeader(trip: Trip) -> String?
}

public extension DKHeader {
    func tripListHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func tripDetailHeader() -> HeaderDay {
        return .distanceDuration
    }
    
    func customTripListHeader(trips: [Trip]) -> String? {
        return nil
    }
    
    func customTripDetailHeader(trip: Trip) -> String? {
        return nil
    }
    
}
