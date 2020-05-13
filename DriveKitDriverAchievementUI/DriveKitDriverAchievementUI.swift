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

public class DriveKitDriverAchievementUI {
    
    public static let shared = DriveKitDriverAchievementUI()
    
    var streakThemes : [DKStreakTheme] = [.phoneDistraction, .safety, .acceleration, .brake, .adherence]
    var badgeCategories : [DKBadgeCategory] = [.generic, .ecodriving, .safety, .phoneDistraction]
    
    private init() {}
    
    public func initialize() {
        DriveKitNavigationController.shared.driverAchievementUI = self
    }
    
    public func configureStreakThemes(streakThemes : [DKStreakTheme]) {
        self.streakThemes = streakThemes
    }
    
    public func configureBadgeCategories(badgeCategories : [DKBadgeCategory]) {
        self.badgeCategories = badgeCategories
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
