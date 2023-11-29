// swiftlint:disable convenience_type
//
//  DKLastTripsUI.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public class DKLastTripsUI {

    public static func getTripsWidget(
        trips: [DKTripListItem],
        headerDay: HeaderDay = .distance,
        tripData: TripData = .safety,
        parentViewController: UIViewController
    ) -> UIView {
        let viewModel = LastTripsViewModel(trips: trips, tripData: tripData, headerDay: headerDay, parentViewController: parentViewController)
        let lastTripsView = LastTripsView.viewFromNib
        lastTripsView.viewModel = viewModel
        return lastTripsView
    }

}
