//
//  DriveKitDriverDataUI.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public class DriveKitDriverDataUI {
    
    var tripData: TripData = .safety
    var headerDay: HeaderDay = .distanceDuration
    var dayTripDescendingOrder: Bool = false
    
    public static let shared = DriveKitDriverDataUI()
    
    private init() {}
    
    public func initialize(tripData : TripData = .safety, headerDay : HeaderDay = .distanceDuration, dayTripDescendingOrder : Bool = false) {
        self.tripData = tripData
        self.headerDay = headerDay
        self.dayTripDescendingOrder = dayTripDescendingOrder
    }

}

extension Bundle {
    static let driverDataUIBundle = Bundle(identifier: "com.drivequant.drivekit-driverdata-ui")
}

extension String {
    public func dkDriverDataLocalized() -> String {
        return self.dkLocalized(tableName: "DriverDataLocalizables", bundle: Bundle.driverDataUIBundle ?? .main)
    }
}

extension DriveKitDriverDataUI : DriveKitDriverDataUIEntryPoint {
    public func getTripListViewController() -> UIViewController {
        return UIViewController()
    }
    
    public func getTripDetailViewController() -> UIViewController {
        return UIViewController()
    }
}
