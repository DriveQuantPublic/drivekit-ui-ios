//
//  TripListViewConfig.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public class TripListViewConfig {
    var tripData: TripData
    var tripInfo: TripInfo
    var headerDay: HeaderDay
    var dayTripDescendingOrder: Bool
    var noTripsRecordedText: String
    var noTripsRecordedImage: String
    var failedToSyncTrip: String
    var primaryColor: UIColor
    var secondaryColor: UIColor
    var okText : String
    var viewTitleText : String
    var cancelText: String
    var primaryFont: UIFont
    
    public init(tripData: TripData = .safety,
         tripInfo: TripInfo = .safety,
         headerDay: HeaderDay = .distanceDuration,
         dayTripDescendingOrder: Bool = false,
         noTripsRecordedText: String = "dk_no_trips_recorded".dkLocalized(),
         noTripsRecordedImage: String = "dk_no_trips_recorded",
         failedToSyncTrip: String = "dk_failed_to_sync_trips".dkLocalized(),
         primaryColor: UIColor = UIColor.dkPrimaryColor,
         secondaryColor: UIColor = UIColor.dkSecondaryColor,
         okText: String = "dk_ok".dkLocalized(),
         viewTitleText : String = "dk_trips_list_title".dkLocalized(),
         cancelText: String = "dk_cancel".dkLocalized(),
         primaryFont : UIFont = UIFont.systemFont(ofSize: CGFloat(UIFont.systemFontSize), weight: .medium)) {
        
        self.tripData = tripData
        self.tripInfo = tripInfo
        self.headerDay = headerDay
        self.dayTripDescendingOrder = dayTripDescendingOrder
        self.noTripsRecordedText = noTripsRecordedText
        self.noTripsRecordedImage = noTripsRecordedImage
        self.failedToSyncTrip = failedToSyncTrip
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.okText = okText
        self.viewTitleText = viewTitleText
        self.cancelText = cancelText
        self.primaryFont = primaryFont
    }
    
}
