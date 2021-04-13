//
//  TripsListViewModel.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 12/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public class TripsListViewModel {
    private(set) var tripList: DKTripsList?

    public init(tripList: DKTripsList) {
        self.tripList = tripList
    }
}
