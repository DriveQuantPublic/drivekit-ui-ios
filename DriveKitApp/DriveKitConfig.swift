//
//  DriveKitConfig.swift
//  DriveKitApp
//
//  Created by David Bauduin on 26/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDriverDataModule
import DriveKitTripAnalysisModule
import DriveKitTripAnalysisUI

class DriveKitConfig {
    // ===============================
    // ↓↓↓ ENTER YOUR API KEY HERE ↓↓↓
    // ===============================
    private static let apiKey = ""

    static let isAutoStartPostponable = true
    static let tripData: TripData = .safety
    static let enableAlternativeTrips = true

    static func configureDriveKit(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        NotificationManager.configure()
        configureDriveKit()
        configureTripAnalysis(launchOptions: launchOptions)
        configureDriverData()
        //TODO
    }

    private static func configureDriveKit() {
        DriveKit.shared.initialize(delegate: DriveKitDelegateManager.shared)
        DriveKit.shared.setApiKey(key: getApiKey())
    }

    private static func configureTripAnalysis(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DriveKitTripAnalysis.shared.initialize(tripListener: TripListenerManager.shared, appLaunchOptions: launchOptions)
        DriveKitTripAnalysis.shared.activateAutoStart(enable: true)
        #warning("TODO: Add a comment to explain why it is needed or not to call setVehiclesConfigTakeover")
        DriveKitTripAnalysis.shared.setVehiclesConfigTakeover(vehiclesConfigTakeOver: true)

        // Crash detection:
        DriveKitTripAnalysis.shared.activateCrashDetection(true)
        let crashFeedbackConfig = DKCrashFeedbackConfig(notification: DKCrashFeedbackNotification(title: "dk_crash_detection_feedback_notif_title".dkTripAnalysisLocalized(), message: "dk_crash_detection_feedback_notif_message".dkTripAnalysisLocalized(), crashAlert: .vibration))
        DriveKitTripAnalysisUI.shared.enableCrashFeedback(roadsideAssistanceNumber: "000000", config: crashFeedbackConfig)
    }

    private static func configureDriverData() {
        DriveKitDriverData.shared.initialize()
    }


    private static func getApiKey() -> String {
        if DriveKitConfig.apiKey.isEmpty {
            let processInfo = ProcessInfo.processInfo
            return processInfo.environment["DriveKit-API-Key"] ?? DriveKit.shared.config.getApiKey() ?? DriveKitConfig.apiKey
        }
        return DriveKitConfig.apiKey
    }
}
