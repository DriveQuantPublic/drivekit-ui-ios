//
//  DriveKitDriverAchievementUI.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBAchievementAccess

@objc public class DriveKitDriverAchievementUI : NSObject {

    @objc public static let shared = DriveKitDriverAchievementUI()

    public private(set) var streakThemes: [DKStreakTheme] = [.phoneDistraction, .safety, .acceleration, .brake, .adherence]
    public private(set) var badgeCategories: [DKBadgeCategory] = [.generic, .ecodriving, .safety, .phoneDistraction]
    public private(set) var rankingType: [DKRankingType] = [.safety, .ecoDriving, .distraction]
    public private(set) var rankingSelector: DKRankingSelectorType = .period(rankingPeriods: [.weekly, .legacy, .monthly])
    public private(set) var rankingDepth: Int = 10

    private override init() {}

    @objc public func initialize() {
        DriveKitNavigationController.shared.driverAchievementUI = self
    }

    public func configureStreakThemes(streakThemes: [DKStreakTheme]) {
        self.streakThemes = streakThemes
    }

    public func configureBadgeCategories(badgeCategories: [DKBadgeCategory]) {
        var newBadgeCategories: [DKBadgeCategory] = (badgeCategories.contains(.generic) ? [] : [.generic])
        newBadgeCategories.append(contentsOf: badgeCategories)
        self.badgeCategories = newBadgeCategories
    }

    public func configureRankingType(_ rankingType: [DKRankingType]) {
        self.rankingType = rankingType
    }

    public func configureRankingSelector(_ rankingSelector: DKRankingSelectorType) {
        self.rankingSelector = rankingSelector
    }

    @objc public func configureRankingDepth(_ rankingDepth: Int) {
        self.rankingDepth = rankingDepth
    }

}

extension Bundle {
    static let driverAchievementUIBundle = Bundle(identifier: "com.drivequant.drivekit-driver-achievement-ui")
}

extension String {
    public func dkAchievementLocalized() -> String {
        return self.dkLocalized(tableName: "DriverAchievementLocalizables", bundle: Bundle.driverAchievementUIBundle ?? .main)
    }
}

extension DriveKitDriverAchievementUI : DriveKitDriverAchievementUIEntryPoint {
    public func getStreakViewController() -> UIViewController {
        return StreakViewController()
    }

    public func getBadgesViewController() -> UIViewController {
        return BadgesViewController()
    }

    public func getLeaderboardViewController() -> UIViewController {
        return LeaderboardViewController()
    }
}

// MARK: - Objective-C extension

extension DriveKitDriverAchievementUI {

    @objc(configureStreakThemes:) // Usage example: [DriveKitDriverAchievementUI.shared configureStreakThemes:@[ @(DKStreakThemePhoneDistraction), @(DKStreakThemeSafety), @(DKStreakThemeAcceleration), @(DKStreakThemeBrake), @(DKStreakThemeAdherence) ]];
    public func objc_configureStreakThemes(_ streakThemes: [Int]) {
        configureStreakThemes(streakThemes: streakThemes.map { DKStreakTheme(rawValue: $0)! })
    }

    @objc(configureBadgeCategories:) // Usage example: [DriveKitDriverAchievementUI.shared configureBadgeCategories:@[ @(DKBadgeCategoryGeneric), @(DKBadgeCategoryEcodriving), @(DKBadgeCategorySafety), @(DKBadgeCategoryPhoneDistraction) ]];
    public func objc_configureBadgeCategories(_ badgeCategories: [Int]) {
        configureBadgeCategories(badgeCategories: badgeCategories.map { DKBadgeCategory(rawValue: $0)! })
    }

    @objc(configureRankingType:) // Usage example: [DriveKitDriverAchievementUI.shared configureRankingType:@[ @(DKRankingTypeSafety), @(DKRankingTypeEcoDriving), @(DKRankingTypeDistraction) ]];
    public func objc_configureRankingType(_ rankingType: [Int]) {
        configureRankingType(rankingType.map { DKRankingType(rawValue: $0)! })
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
