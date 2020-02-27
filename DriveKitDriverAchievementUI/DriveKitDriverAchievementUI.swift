//
//  DriveKitDriverAchievementUI.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

public class DriveKitDriverAchievementUI {
    
}

extension Bundle {
    static let driverAchievementUIBundle = Bundle(identifier: "com.drivequant.drivekit-driver-achievement-ui")
}

extension String {
    public func dkAchievementLocalized() -> String {
        return self.dkLocalized(tableName: "DriverAchievementLocalizables", bundle: Bundle.driverAchievementUIBundle ?? .main)
    }
}
