//
//  BadgeLevelViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/15/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBAchievementAccess

class BadgeLevelViewModel {
    let level: DKBadgeLevel
    
    init(level: DKBadgeLevel) {
        self.level = level
    }

    var tripsLeft: Int {
        return Int(round(Double(level.threshold) - level.progressValue))
    }

    var title: String {
        return level.nameKey.dkAchievementLocalized()
    }

    var iconKey: String {
        return tripsLeft > 0 ? level.defaultIconKey : level.iconKey
    }

    var description: String {
        return level.descriptionKey.dkAchievementLocalized()
    }

    var progress: String {
        return level.progressKey.dkAchievementLocalized()
    }

    var congrats: String {
        return level.congratsKey.dkAchievementLocalized()
    }

    var levelValue: DKLevel {
        return level.level
    }

    var threshold: Int {
        return level.threshold
    }

    var progressValue: Double {
        return level.progressValue
    }
}
