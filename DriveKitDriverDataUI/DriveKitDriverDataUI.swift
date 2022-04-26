//
//  DriveKitDriverDataUI.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule

public class DriveKitDriverDataUI: AccessRightListener {
    private(set) var tripData: TripData = .safety
    private(set) var sourceMapItems: [MapItem] = [.safety, .ecoDriving, .distraction, .speeding, .interactiveMap, .synthesis]
    private(set) var mapItems: [MapItem] = [.safety, .ecoDriving, .distraction, .speeding, .interactiveMap, .synthesis]
    private(set) var headerDay: HeaderDay = .durationDistance
    private(set) var dayTripDescendingOrder: Bool = false
    private(set) var customMapItem: DKMapItem?
    private(set) var enableDeleteTrip = true
    private(set) var enableAdviceFeedback = true
    public private(set) var enableAlternativeTrips = false
    private(set) var enableVehicleFilter = true
    private(set) var customHeaders: DKHeader?
    private(set) var customTripInfo: DKTripInfo?

    public static let shared = DriveKitDriverDataUI()
    
    private init() {}

    public func initialize(tripData: TripData = .safety, mapItems: [MapItem] = [.safety, .ecoDriving, .distraction, .speeding, .interactiveMap, .synthesis]) {
        self.tripData = tripData
        self.sourceMapItems = mapItems
        filterMapItems()
        DriveKitAccess.shared.addAccessRightListener(self)
        DriveKitNavigationController.shared.driverDataUI = self
    }

    deinit {
        DriveKitAccess.shared.removeAccessRightListener(self)
    }

    public func configureTripData(_ tripData: TripData) {
        self.tripData = tripData
    }
    
    public func configureHeaderDay(headerDay: HeaderDay) {
        self.headerDay = headerDay
    }
    
    public func configureDayTripDescendingOrder(dayTripDescendingOrder: Bool) {
        self.dayTripDescendingOrder = dayTripDescendingOrder
    }
    
    public func enableDeleteTrip(enable: Bool) {
        self.enableDeleteTrip = enable
    }
    
    public func enableAdviceFeedback(enable: Bool) {
        self.enableAdviceFeedback = enable
    }
    
    public func setCustomMapItem(_ mapItem: DKMapItem?) {
        self.customMapItem = mapItem
    }
    
    public func customizeHeaders(headers: DKHeader?) {
        self.customHeaders = headers
    }

    public func setCustomTripInfo(_ tripInfo: DKTripInfo?) {
        self.customTripInfo = tripInfo
    }
    
    public func enableAlternativeTrips(_ enable: Bool) {
        self.enableAlternativeTrips = enable
    }

    public func enableVehicleFilter(_ enable: Bool) {
        self.enableVehicleFilter = enable
    }

    public func getLastTripsSynthesisCardsView(_ synthesisCards: [LastTripsSynthesisCard] = [.safety, .ecodriving, .distraction, .speeding]) -> UIView {
        return DriverDataSynthesisCardsUI.getLastTripsSynthesisCardsView(synthesisCards)
    }

    public func getLastTripsView(
        lastTripsMaxNumber: Int = 10,
        headerDay: HeaderDay = .distance,
        parentViewController: UIViewController
    ) -> UIView {
        let trips = LastTripsWidgetUtils.getLastTrips(limit: lastTripsMaxNumber)
        return DKLastTripsUI.getTripsWidget(trips: trips, headerDay: headerDay, tripData: self.tripData, parentViewController: parentViewController)
    }

    private func filterMapItems() {
        self.mapItems = sourceMapItems.filter({
            $0.hasAccess()
        })
    }

    // MARK: AccessRightListener protocol implementation
    public func onAccessRightsUpdated() {
        filterMapItems()
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

extension DriveKitDriverDataUI: DriveKitDriverDataUIEntryPoint {
    public func getTripListViewController() -> UIViewController {
        return TripListVC()
    }
    
    public func getTripDetailViewController(itinId: String, showAdvice: Bool, alternativeTransport: Bool) -> UIViewController {
        return TripDetailVC(itinId: itinId, showAdvice: showAdvice, listConfiguration: alternativeTransport ? .alternative() : .motorized())
    }
}

extension UIColor {
    public static let dkMapTrace = UIColor(hex: 0x116ea9)
    public static let dkMapTraceAuthorizedCall = UIColor(hex: 0x93c47d)
    public static let dkMapTraceWarning = UIColor(hex: 0xed4f3b)
}
