//
//  DriveKitNavigationController.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public class DriveKitNavigationController {
    public var driverDataUI: DriveKitDriverDataUIEntryPoint? = nil
    public var driverAchievementUI: DriveKitDriverAchievementUIEntryPoint? = nil
    public var vehicleUI: DriveKitVehicleUIEntryPoint? = nil
    public var permissionsUtilsUI: DriveKitPermissionsUtilsUIEntryPoint? = nil
    public var challengeUI: DriveKitChallengeUIEntryPoint? = nil

    public static let shared = DriveKitNavigationController()

    private init() {}
}
