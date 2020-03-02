//
//  DriveKitDriverAchievementUI.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

public class DriveKitDriverAchievementUI {
    
    public static let shared = DriveKitDriverAchievementUI()
    
    var streakData : [StreakDataType] = [.phoneDistraction, .safety, .acceleration, .brake, .adherence, .speedLimits]
    
    private init() {}
    
    public func initialize() {
        DriveKitNavigationController.shared.driverAchievementUI = self
    }
    
    public func setStreakData(streakData : [StreakDataType]) {
        self.streakData = streakData
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
}
