//
//  DriveKitConfig.swift
//  DriveKitApp
//
//  Created by David Bauduin on 26/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitChallengeModule
import DriveKitChallengeUI
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBAchievementAccessModule
import DriveKitDriverAchievementModule
import DriveKitDriverAchievementUI
import DriveKitDriverDataModule
import DriveKitDriverDataUI
import DriveKitPermissionsUtilsUI
import DriveKitTripAnalysisModule
import DriveKitTripAnalysisUI
import DriveKitVehicleModule
import DriveKitVehicleUI

class DriveKitConfig {
    // ===============================
    // ↓↓↓ ENTER YOUR API KEY HERE ↓↓↓
    // ===============================
    private static let apiKey = ""

    static let isAutoStartPostponable = true
    private static let tripData: TripData = .safety
    private static let enableAlternativeTrips = true
    private static let enableTripAnalysisCrashDetection = true
    private static let enableVehicleOdometer = true
    private static let vehicleTypes: [DKVehicleType] = DKVehicleType.allCases
    private static let vehicleBrands = DKVehicleBrand.allCases

    static func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Configure trip notifications:
        NotificationManager.configure()

        // Internal modules configuration:
        configureCore()
        configureTripAnalysis(launchOptions: launchOptions)
        configureDriverData()

        // UI modules configuration:
        configureCommonUI()
        configureDriverDataUI()
        configureVehicleUI()
        configureTripAnalysisUI()
        configureDriverAchievementUI()
        configurePermissionsUtilsUI()
        configureChallengeUI()
    }

    static func isTripAnalysisAutoStartEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: Constants.tripAnalysisAutoStart.key) == nil {
            return true
        } else {
            return UserDefaults.standard.bool(forKey: Constants.tripAnalysisAutoStart.key)
        }
    }

    static func enableTripAnalysisAutoStart(_ enable: Bool) {
        UserDefaults.standard.set(enable, forKey: Constants.tripAnalysisAutoStart.key)
        DriveKitTripAnalysis.shared.activateAutoStart(enable: enable)
    }

    static func reset() {
        let apiKey = DriveKit.shared.config.getApiKey()
        DriveKit.shared.reset()
        DriveKitTripAnalysis.shared.reset()
        DriveKitDriverData.shared.reset()
        DriveKitVehicle.shared.reset()
        DriveKitDriverAchievement.shared.reset()
        DriveKitChallenge.shared.reset()
        if let apiKey = apiKey {
            DriveKit.shared.setApiKey(key: apiKey)
        }
        // Clear all UserDefaults.
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }


    private static func configureCore() {
        DriveKit.shared.initialize(delegate: DriveKitDelegateManager.shared)
        let apiKey = getApiKey()
        if apiKey != DriveKit.shared.config.getApiKey() {
            DriveKitConfig.reset()
        }
        DriveKit.shared.setApiKey(key: apiKey)
    }

    private static func configureTripAnalysis(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DriveKitTripAnalysis.shared.initialize(tripListener: TripListenerManager.shared, appLaunchOptions: launchOptions)
        DriveKitTripAnalysis.shared.activateAutoStart(enable: isTripAnalysisAutoStartEnabled())
        DriveKitTripAnalysis.shared.activateCrashDetection(DriveKitConfig.enableTripAnalysisCrashDetection)

        // You must call this method if you use DriveKit Vehicle component:
        DriveKitTripAnalysis.shared.setVehiclesConfigTakeover(vehiclesConfigTakeOver: true)
    }

    private static func configureDriverData() {
        DriveKitDriverData.shared.initialize()
    }


    private static func configureCommonUI() {
        DriveKitUI.shared.initialize(colors: DefaultColors(), fonts: DefaultFonts(), overridedStringsFileName: "Localizable")
        DriveKitUI.shared.configureAnalytics(Analytics())
    }

    private static func configureDriverDataUI() {
        DriveKitDriverDataUI.shared.initialize(tripData: DriveKitConfig.tripData)
        DriveKitDriverDataUI.shared.enableAlternativeTrips(DriveKitConfig.enableAlternativeTrips)
    }

    private static func configureVehicleUI() {
        DriveKitVehicleUI.shared.initialize()
        DriveKitVehicleUI.shared.enableOdometer(DriveKitConfig.enableVehicleOdometer)
        DriveKitVehicleUI.shared.configureVehicleTypes(types: DriveKitConfig.vehicleTypes)
        DriveKitVehicleUI.shared.configureBrands(brands: DriveKitConfig.vehicleBrands)
    }

    private static func configureTripAnalysisUI() {
        DriveKitTripAnalysisUI.shared.initialize()
        let crashFeedbackConfig = DKCrashFeedbackConfig(notification: DKCrashFeedbackNotification(title: "dk_crash_detection_feedback_notif_title".dkTripAnalysisLocalized(), message: "dk_crash_detection_feedback_notif_message".dkTripAnalysisLocalized(), crashAlert: .silence))
        DriveKitTripAnalysisUI.shared.enableCrashFeedback(roadsideAssistanceNumber: "000000", config: crashFeedbackConfig)
    }

    private static func configureDriverAchievementUI() {
        DriveKitDriverAchievementUI.shared.initialize()
        DriveKitDriverAchievementUI.shared.configureRankingTypes(DKRankingType.allCases)
        DriveKitDriverAchievementUI.shared.configureRankingSelector(DKRankingSelectorType.period(rankingPeriods: [.weekly, .monthly, .allTime]))
        DriveKitDriverAchievementUI.shared.configureBadgeCategories(badgeCategories: [.generic, .ecodriving, .safety, .phoneDistraction,  .call])
        DriveKitDriverAchievementUI.shared.configureRankingDepth(5)
    }

    private static func configurePermissionsUtilsUI() {
        DriveKitPermissionsUtilsUI.shared.initialize()
        DriveKitPermissionsUtilsUI.shared.configureBluetooth(needed: DriveKitConfig.isBluetoothNeeded())
        DriveKitPermissionsUtilsUI.shared.configureContactType(DKContactType.email(ContentMail()))
    }

    private static func configureChallengeUI() {
        DriveKitChallengeUI.shared.initialize()
    }


    private static func isBluetoothNeeded() -> Bool {
        let vehicles = DriveKitVehicle.shared.vehiclesQuery().noFilter().query().execute()
        let isBluetoothNeeded = vehicles.contains { vehicle -> Bool in
            vehicle.detectionMode == .beacon || vehicle.detectionMode == .bluetooth
        }
        return isBluetoothNeeded
    }


    static func getApiKey() -> String {
        if DriveKitConfig.apiKey.isEmpty {
            let processInfo = ProcessInfo.processInfo
            return processInfo.environment["DriveKit-API-Key"] ?? DriveKit.shared.config.getApiKey() ?? DriveKitConfig.apiKey
        }
        return DriveKitConfig.apiKey
    }

    private enum Constants {
        case tripAnalysisAutoStart

        var key: String {
            switch self {
                case .tripAnalysisAutoStart:
                    return "tripAnalysisAutoStartKey"
            }
        }
    }
}

private class DefaultColors: DKDefaultColors {
}

private class DefaultFonts: DKDefaultFonts {
}

private class ContentMail: DKContentMail {
    func overrideMailBodyContent() -> Bool {
        return false
    }

    func getRecipients() -> [String] {
        return ["recipient_to_configure@mail.com"]
    }

    func getBccRecipients() -> [String] {
        return []
    }

    func getSubject() -> String {
        return "[Subject to configure]"
    }

    func getMailBody() -> String {
        return "[Mail body to configure]"
    }
}
