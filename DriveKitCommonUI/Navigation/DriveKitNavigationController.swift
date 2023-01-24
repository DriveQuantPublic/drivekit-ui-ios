//
//  DriveKitNavigationController.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public class DriveKitNavigationController {
    public var driverDataUI: DriveKitDriverDataUIEntryPoint?
    public var driverDataTimelineUI: DriveKitDriverDataTimelineUIEntryPoint?
    public var driverAchievementUI: DriveKitDriverAchievementUIEntryPoint?
    public var vehicleUI: DriveKitVehicleUIEntryPoint?
    public var permissionsUtilsUI: DriveKitPermissionsUtilsUIEntryPoint?
    public var challengeUI: DriveKitChallengeUIEntryPoint?
    public var tripAnalysisUI: DriveKitTripAnalysisUIEntryPoint?

    public static let shared = DriveKitNavigationController()

    private init() {}
}
