// swiftlint:disable line_length
//
//  DriveKitDriverAchievementUI.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitCommonUI
import DriveKitDBAchievementAccessModule

@objc public class DriveKitDriverAchievementUI: NSObject {
    static let tag = "DriveKit Driver Achievement UI"

    @objc public static let shared = DriveKitDriverAchievementUI()

    public private(set) var streakThemes: [DKStreakTheme] = [.phoneDistraction, .safety, .acceleration, .brake, .adherence, .speedLimits, .call]
    public private(set) var badgeCategories: [DKBadgeCategory] = [.generic, .ecodriving, .safety, .phoneDistraction, .call]
    public private(set) var rankingTypes: [DKRankingType] = [.safety, .ecoDriving, .distraction]
    public private(set) var rankingSelector: DKRankingSelectorType = .period(rankingPeriods: [.weekly, .monthly, .allTime])
    public private(set) var rankingDepth: Int = 5

    private override init() {
        super.init()
        DriveKitLog.shared.infoLog(tag: DriveKitDriverAchievementUI.tag, message: "Initialization")
        DriveKitNavigationController.shared.driverAchievementUI = self
    }

    @objc public func initialize() {
        // Nothing to do currently.
    }

    public func configureStreakThemes(streakThemes: [DKStreakTheme]) {
        self.streakThemes = streakThemes
    }

    public func configureBadgeCategories(badgeCategories: [DKBadgeCategory]) {
        var newBadgeCategories: [DKBadgeCategory] = (badgeCategories.contains(.generic) ? [] : [.generic])
        newBadgeCategories.append(contentsOf: badgeCategories)
        self.badgeCategories = newBadgeCategories
    }

    public func configureRankingTypes(_ rankingTypes: [DKRankingType]) {
        self.rankingTypes = rankingTypes
    }

    public func configureRankingSelector(_ rankingSelector: DKRankingSelectorType) {
        self.rankingSelector = rankingSelector
    }

    @objc public func configureRankingDepth(_ rankingDepth: Int) {
        self.rankingDepth = rankingDepth
    }
}

extension Bundle {
#if SWIFT_PACKAGE
    static let driverAchievementUIBundle: Bundle? = Bundle.module
#else
    static let driverAchievementUIBundle = Bundle(identifier: "com.drivequant.drivekit-driver-achievement-ui")
#endif
}

extension String {
    public func dkAchievementLocalized() -> String {
        return self.dkLocalized(tableName: "DriverAchievementLocalizables", bundle: Bundle.driverAchievementUIBundle ?? .main)
    }
}

extension DriveKitDriverAchievementUI: DriveKitDriverAchievementUIEntryPoint {
    public func getStreakViewController() -> UIViewController {
        return StreakViewController()
    }

    public func getBadgesViewController() -> UIViewController {
        return BadgesViewController()
    }

    public func getRankingViewController(groupName: String?) -> UIViewController {
        return RankingViewController(groupName: groupName)
    }
}

// MARK: - Objective-C extension

extension DriveKitDriverAchievementUI {
    @objc(configureStreakThemes:) // Usage example: [DriveKitDriverAchievementUI.shared configureStreakThemes:@[ @(DKStreakThemePhoneDistraction), @(DKStreakThemeSafety), @(DKStreakThemeAcceleration), @(DKStreakThemeBrake), @(DKStreakThemeAdherence) ]];
    public func objc_configureStreakThemes(_ streakThemes: [Int]) {
        configureStreakThemes(streakThemes: streakThemes.map { DKStreakTheme(rawValue: $0)! })
    }

    @objc(configureBadgeCategories:) // Usage example: [DriveKitDriverAchievementUI.shared configureBadgeCategories:@[ @(DKBadgeCategoryGeneric), @(DKBadgeCategoryEcodriving), @(DKBadgeCategorySafety), @(DKBadgeCategoryPhoneDistraction), @(DKBadgeCategoryCall) ]];
    public func objc_configureBadgeCategories(_ badgeCategories: [Int]) {
        configureBadgeCategories(badgeCategories: badgeCategories.map { DKBadgeCategory(rawValue: $0)! })
    }

    @objc(configureRankingTypes:) // Usage example: [DriveKitDriverAchievementUI.shared configureRankingTypes:@[ @(DKRankingTypeSafety), @(DKRankingTypeEcoDriving), @(DKRankingTypeDistraction) ]];
    public func objc_configureRankingTypes(_ rankingTypes: [Int]) {
        configureRankingTypes(rankingTypes.map { DKRankingType(rawValue: $0)! })
    }

    @objc(configureRankingSelectorNone)
    public func objc_configureRankingSelectorNone() {
        configureRankingSelector(.none)
    }

    @objc(configureRankingSelectorPeriods:) // Usage example: [DriveKitDriverAchievementUI.shared configureRankingSelectorPeriod:@[ @(DKRankingPeriodWeekly), @(DKRankingPeriodLegacy), @(DKRankingPeriodMonthly) ]];
    public func objc_configureRankingSelectorPeriods(_ periods: [Int]) {
        configureRankingSelector(.period(rankingPeriods: periods.map { DKRankingPeriod(rawValue: $0)! }))
    }
}

@objc(DKUIDriverAchievementInitializer)
class DKUIDriverAchievementInitializer: NSObject {
    @objc static func initUI() {
        DriveKitDriverAchievementUI.shared.initialize()
    }
}
