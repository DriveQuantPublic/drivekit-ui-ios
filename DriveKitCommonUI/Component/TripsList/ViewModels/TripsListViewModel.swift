//
//  TripsListViewModel.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 12/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public struct TripsListViewModel {
    weak private(set) var tripList: DKTripList?

    public init(tripList: DKTripList) {
        self.tripList = tripList
    }
}
