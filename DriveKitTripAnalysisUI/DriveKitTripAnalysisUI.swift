//
//  DriveKitTripAnalysisUI.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitTripAnalysisModule

@objc public class DriveKitTripAnalysisUI: NSObject {
    @objc public static let shared = DriveKitTripAnalysisUI()
    private(set) public var defaultWorkingHours: DKActivationHours = DriveKitTripAnalysisUI.getDefaultWorkingHours()
    private var activationHoursVC: ActivationHoursViewController?
    
    @objc public func initialize() {
        DriveKitNavigationController.shared.tripAnalysisUI = self
    }

    private static func getDefaultWorkingHours() -> DKActivationHours {
        let days: [DKDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let activationHoursDayConfigurations: [DKActivationHoursDayConfiguration] = days.map { day in
            DKActivationHoursDayConfiguration(
                day: day,
                entireDayOff: day == .saturday || day == .sunday,
                startTime: 8,
                endTime: 18,
                reverse: false
            )
        }
        return DKActivationHours(
            enabled: false,
            insideHours: .business,
            outsideHours: .personal,
            activationHoursDayConfigurations: activationHoursDayConfigurations
        )
    }
}

extension DriveKitTripAnalysisUI: DriveKitTripAnalysisUIEntryPoint {
    public func getActivationHoursViewController() -> UIViewController {
        let activationHoursVC = ActivationHoursViewController()
        self.activationHoursVC = activationHoursVC
        return activationHoursVC

    }
}

extension Bundle {
    static let tripAnalysisUIBundle = Bundle(identifier: "com.drivequant.drivekit-trip-analysis-ui")
}

extension String {
    public func dkTripAnalysisLocalized() -> String {
        return self.dkLocalized(tableName: "DKTripAnalysisLocalizable", bundle: Bundle.tripAnalysisUIBundle ?? .main)
    }
}
