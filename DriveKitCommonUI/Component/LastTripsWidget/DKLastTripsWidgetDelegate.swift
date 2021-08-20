//
//  DKLastTripsWidgetDelegate.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public protocol DKLastTripsWidgetDelegate : AnyObject {
    func didSelectTrip(_ trip: DKTripListItem)
    func openTripList()
}
