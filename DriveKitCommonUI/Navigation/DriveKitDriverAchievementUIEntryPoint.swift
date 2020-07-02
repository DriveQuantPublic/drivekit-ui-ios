//
//  DriveKitDriverAchievementEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public protocol DriveKitDriverAchievementUIEntryPoint {
    func getStreakViewController() -> UIViewController
    
    func getBadgesViewController() -> UIViewController

    func getLeaderboardViewController() -> UIViewController
}
