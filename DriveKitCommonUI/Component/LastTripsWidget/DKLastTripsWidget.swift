//
//  DKLastTripsWidget.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public class DKLastTripsWidget {

    public static func getTripsWidget(
        trips: [DKTripListItem],
        headerDay: HeaderDay = .distance,
        tripData: TripData = .safety,
        parentViewController: UIViewController? = nil,
        delegate: DKLastTripsWidgetDelegate?
    ) -> UIView {
        let viewModel = LastTripsViewModel(trips: trips, tripData: tripData, headerDay: headerDay, parentViewController: parentViewController, delegate: delegate)
        let lastTripsView = LastTripsView.viewFromNib
        lastTripsView.viewModel = viewModel
        return lastTripsView
    }

}
