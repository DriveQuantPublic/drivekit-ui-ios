//
//  LastTripsViewModel.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

struct LastTripsViewModel {
    let trips: [DKTripListItem]
    let tripData: TripData
    weak var parentViewController: UIViewController?
    weak var delegate: DKLastTripsWidgetDelegate?
}
