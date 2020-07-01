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
}

// MARK: - Objective-C extension

extension DriveKitDriverAchievementUI {

    @objc(configureStreakThemes:) // Usage example: [DriveKitDriverAchievementUI.shared configureStreakThemes:@[ @(DKStreakThemePhoneDistraction), @(DKStreakThemeSafety), @(DKStreakThemeAcceleration), @(DKStreakThemeBrake), @(DKStreakThemeAdherence) ]];
    public func objc_configureStreakThemes(streakThemes: [Int]) {
        configureStreakThemes(streakThemes: streakThemes.map { DKStreakTheme(rawValue: $0)! })
    }

    @objc(configureBadgeCategories:) // Usage example: [DriveKitDriverAchievementUI.shared configureBadgeCategories:@[ @(DKBadgeCategoryGeneric), @(DKBadgeCategoryEcodriving), @(DKBadgeCategorySafety), @(DKBadgeCategoryPhoneDistraction) ]];
    public func objc_configureBadgeCategories(badgeCategories: [Int]) {
        configureBadgeCategories(badgeCategories: badgeCategories.map { DKBadgeCategory(rawValue: $0)! })
    }

}
