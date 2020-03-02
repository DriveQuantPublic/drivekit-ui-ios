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
    var mapItems : [MapItem] = [.safety, .ecoDriving, .distraction, .interactiveMap, .synthesis]
    var enableDeleteTrip = true
    
    public static let shared = DriveKitDriverDataUI()
    
    private init() {}
    
    public func initialize(tripData : TripData = .safety, mapItems: [MapItem] = [.safety, .ecoDriving, .distraction, .interactiveMap, .synthesis]) {
        self.tripData = tripData
        self.mapItems = mapItems
    }
    
    public func setHeaderDay(headerDay : HeaderDay) {
        self.headerDay = headerDay
    }
    
    public func setDayTripDescendingOrder(dayTripDescendingOrder : Bool) {
        self.dayTripDescendingOrder = dayTripDescendingOrder
    }
    
    public func enableDeleteTrip(enableDeleteTrip : Bool) {
        self.enableDeleteTrip = enableDeleteTrip
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
        return TripListVC()
    }
    
    public func getTripDetailViewController(itinId : String) -> UIViewController {
        return TripDetailVC(itinId: itinId, showAdvice: false)
    }
}

extension UIColor {
    public static let dkMapTrace = UIColor(hex: 0x116ea9)
    public static let dkMapTraceWarning = UIColor(hex: 0xed4f3b)
}
