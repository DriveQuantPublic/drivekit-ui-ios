// swiftlint:disable all
//
//  BadgeLevelViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/15/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBAchievementAccessModule

class BadgeLevelViewModel {
    let level: DKBadgeCharacteristics
    
    init(level: DKBadgeCharacteristics) {
        self.level = level
    }

    var tripsLeft: Int {
        return Int(round(Double(level.threshold) - level.progressValue))
    }

    var title: String {
        return level.name.dkAchievementLocalized()
    }

    var iconKey: String {
        return tripsLeft > 0 ? level.defaultIcon : level.icon
    }

    var description: String {
        return level.descriptionValue.dkAchievementLocalized()
    }

    var progress: String {
        return level.progress.dkAchievementLocalized()
    }

    var congrats: String {
        return level.congrats.dkAchievementLocalized()
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
