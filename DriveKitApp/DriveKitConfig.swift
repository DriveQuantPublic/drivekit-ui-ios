// swiftlint:disable all
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
import DriveKitDriverDataTimelineUI
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

    private static let tripData: TripData = .safety
    private static let enableAlternativeTrips = true
    private static let enableTripAnalysisCrashDetection = true
    private static let enableVehicleOdometer = true
    private static let vehicleTypes: [DKVehicleType] = DKVehicleType.allCases
    private static let vehicleBrands: [DKVehicleBrand] = DKVehicleBrand.allCases

    static func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // DriveKit modules initialization:
        initializeModules(launchOptions: launchOptions)

        // DriveKit modules configuration:
        configureModules()

        // Configure trip notifications:
        NotificationManager.configure()
    }

    private static func initializeModules(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // DriveKit Initialization:
        DriveKit.shared.initialize()

        // TripAnalysis initialization:
        DriveKitTripAnalysis.shared.initialize(tripListener: nil, appLaunchOptions: launchOptions)

        // Initialize DriverData:
        DriveKitDriverData.shared.initialize()
    }

    private static func configureModules() {
        // Internal modules configuration:
        configureCore()
        configureTripAnalysis()

        // UI modules configuration:
        configureCommonUI()
        configureDriverDataUI()
        configureDriverDataTimelineUI()
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

    static func logout() {
        // Reset DriveKit modules:
        reset()

        // Reconfigure modules:
        configureModules()

        // Reconfigure trip notifications manager:
        NotificationManager.configure()
    }

    static func reset() {
        // Reset DriveKit:
        DriveKit.shared.reset()
        DriveKitTripAnalysis.shared.reset()
        DriveKitDriverData.shared.reset()
        DriveKitVehicle.shared.reset()
        DriveKitDriverAchievement.shared.reset()
        DriveKitChallenge.shared.reset()

        // Clear all UserDefaults:
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        // Reset trip notifications manager:
        NotificationManager.reset()

        // Reset App related variables
        AppNavigationController.alreadyOnboarded = false
    }

    private static func configureCore() {
        let apiKey = getApiKey()
        if apiKey != DriveKit.shared.config.getApiKey() {
            reset()
        }
        DriveKit.shared.setApiKey(key: apiKey)
    }

    private static func configureTripAnalysis() {
        DriveKitTripAnalysis.shared.activateAutoStart(enable: isTripAnalysisAutoStartEnabled())
        DriveKitTripAnalysis.shared.activateCrashDetection(DriveKitConfig.enableTripAnalysisCrashDetection)
        
        DriveKitTripAnalysisUI.shared.tripRecordingUserMode = .startStop

        // You must call this method if you use DriveKit Vehicle component:
        DriveKitTripAnalysis.shared.setVehiclesConfigTakeover(vehiclesConfigTakeOver: true)
    }

    private static func configureCommonUI() {
        DriveKitUI.shared.initialize(colors: DefaultColors(), fonts: DefaultFonts(), overridedStringsFileName: "Localizable")
        DriveKitUI.shared.configureAnalytics(Analytics())
    }

    private static func configureDriverDataUI() {
        DriveKitDriverDataUI.shared.initialize(tripData: DriveKitConfig.tripData)
        DriveKitDriverDataUI.shared.enableAlternativeTrips(DriveKitConfig.enableAlternativeTrips)
    }

    private static func configureDriverDataTimelineUI() {
        DriveKitDriverDataTimelineUI.shared.initialize()
    }

    private static func configureVehicleUI() {
        DriveKitVehicleUI.shared.initialize()
        DriveKitVehicleUI.shared.enableOdometer(DriveKitConfig.enableVehicleOdometer)
        DriveKitVehicleUI.shared.configureVehicleTypes(types: DriveKitConfig.vehicleTypes)
        DriveKitVehicleUI.shared.configureBrands(brands: DriveKitConfig.vehicleBrands)
    }

    private static func configureTripAnalysisUI() {
        DriveKitTripAnalysisUI.shared.initialize()
        let crashFeedbackConfig = DKCrashFeedbackConfig(notification: DKCrashFeedbackNotification(
            title: "dk_crash_detection_feedback_notif_title".dkTripAnalysisLocalized(),
            message: "dk_crash_detection_feedback_notif_message".dkTripAnalysisLocalized(),
            crashAlert: .silence
        ))
        DriveKitTripAnalysisUI.shared.enableCrashFeedback(roadsideAssistanceNumber: "000000", config: crashFeedbackConfig)
    }

    private static func configureDriverAchievementUI() {
        DriveKitDriverAchievementUI.shared.initialize()
        DriveKitDriverAchievementUI.shared.configureRankingTypes(DKRankingType.allCases)
        DriveKitDriverAchievementUI.shared.configureRankingSelector(DKRankingSelectorType.period(rankingPeriods: [.weekly, .monthly, .allTime]))
        DriveKitDriverAchievementUI.shared.configureBadgeCategories(badgeCategories: [.generic, .ecodriving, .safety, .phoneDistraction, .call])
        DriveKitDriverAchievementUI.shared.configureRankingDepth(5)
    }

    private static func configurePermissionsUtilsUI() {
        DriveKitPermissionsUtilsUI.shared.initialize()
        DriveKitPermissionsUtilsUI.shared.configureContactType(DKContactType.email(ContentMail()))
    }

    private static func configureChallengeUI() {
        DriveKitChallengeUI.shared.initialize()
    }

    static func getApiKey() -> String {
        if DriveKitConfig.apiKey.isEmpty {
            // This behavior is specific to DriveQuant. You must not do this in your project but return directly `DriveKitConfig.apiKey`:
            return DriveQuantSpecific.getSavedApiKey() ?? ""
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
