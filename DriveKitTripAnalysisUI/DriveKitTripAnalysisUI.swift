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
    @objc public var defaultWorkingHours: DKWorkingHours = DriveKitTripAnalysisUI.getDefaultWorkingHours()

    @objc public func initialize() {
        DriveKitNavigationController.shared.tripAnalysisUI = self
    }

    private static func getDefaultWorkingHours() -> DKWorkingHours {
        let days: [DKDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let workingHoursDayConfigurations: [DKWorkingHoursDayConfiguration] = days.map { day in
            DKWorkingHoursDayConfiguration(
                day: day,
                entireDayOff: day == .saturday || day == .sunday,
                startTime: 8,
                endTime: 18,
                reverse: false
            )
        }
        return DKWorkingHours(
            enabled: false,
            insideHours: .business,
            outsideHours: .personal,
            workingHoursDayConfigurations: workingHoursDayConfigurations
        )
    }
}

extension DriveKitTripAnalysisUI: DriveKitTripAnalysisUIEntryPoint {
    public func getWorkingHoursViewController() -> UIViewController {
        let workingHoursVC = WorkingHoursViewController()
        return workingHoursVC
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
