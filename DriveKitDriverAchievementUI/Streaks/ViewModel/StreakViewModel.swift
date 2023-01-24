//
//  StreakViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 07/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverAchievementModule
import DriveKitDBAchievementAccessModule
import UIKit
import DriveKitCommonUI

class StreakViewModel {
    weak var delegate: StreakVMDelegate?
    var streakData: [StreakData] = []
    
    init() {
        self.streakData = computeStreak(DriveKitDBAchievementAccess.shared.streakQuery().noFilter().query().execute())
    }
    
    func getStreakData() {
        DriveKitDriverAchievement.shared.getStreaks { [weak self] status, streaks in
            if let self = self {
                self.streakData = self.computeStreak(streaks)
                if self.streakData.isEmpty {
                    if let delegate = self.delegate {
                        delegate.failedToUpdateStreak(status: status)
                    }
                } else {
                    if let delegate = self.delegate {
                        delegate.streaksUpdated(status: status)
                    }
                }
            }
        }
    }
    
    private func computeStreak(_ streaks: [DKStreak]) -> [StreakData] {
        var result: [StreakData] = []
        var allStreaks: [StreakData] = []
        for streak in streaks {
            allStreaks.append(StreakData(streak: streak))
        }
        for configuredStreak in DriveKitDriverAchievementUI.shared.streakThemes {
            if let streak = (allStreaks.filter { configuredStreak == $0.type }).first {
                result.append(streak)
            }
        }
        return result
    }
}

protocol StreakVMDelegate: AnyObject {
    func streaksUpdated(status: StreakSyncStatus)
    func failedToUpdateStreak(status: StreakSyncStatus)
}

struct StreakData {
    let type: DKStreakTheme
    let status: StreakStatus
    let streak: DKStreak
    let progressPercent: Int
    
    init(streak: DKStreak) {
        self.streak = streak
        self.type = streak.theme
        if streak.best.tripNumber == streak.current.tripNumber {
            if streak.current.tripNumber == 0 {
                status = .initialization
                progressPercent = 0
            } else {
                status = .best
                progressPercent = 100
            }
        } else {
            if streak.current.tripNumber == 0 {
                status = .reset
                progressPercent = 0
            } else {
                status = .inProgress
                progressPercent = Int((Float(streak.current.tripNumber) / Float(streak.best.tripNumber)) * 100)
            }
        }
    }
    
    func getTitle() -> String {
        return self.type.theme
    }
    
    func getIcon() -> UIImage? {
        return self.type.icon
    }
    
    func getDescriptionText() -> String {
        return self.type.description
    }
    
    func getResetText() -> String {
        return self.type.resetText
    }
    
    func getCurrentTripNumber() -> String {
        return "\(streak.current.tripNumber)"
    }
    
    func getCurrentTripNumberText() -> String {
        return getTripNumberText(tripNumber: streak.current.tripNumber)
    }
    
    func getBestTripNumber() -> String {
        return "\(streak.best.tripNumber)"
    }
    
    func getBestTripNumberText() -> String {
        return getTripNumberText(tripNumber: self.streak.best.tripNumber)
    }
    
    private func getTripNumberText(tripNumber: Int?) -> String {
        var tripsText = DKCommonLocalizable.tripSingular.text()
        if let tripNb = tripNumber, tripNb > 1 {
            tripsText = DKCommonLocalizable.tripPlural.text()
        }
        return tripsText
    }
    
    func getCurrentDistance() -> String {
        return getDistance(distance: streak.current.distance)
    }
    
    func getBestDistance() -> String {
        return getDistance(distance: streak.best.distance)
    }
    
    private func getDistance(distance: Double) -> String {
        return distance.formatMeterDistanceInKm()
    }
    
    func getCurrentDuration() -> String {
        return Double(streak.current.duration).formatSecondDuration(maxUnit: .hour)
    }
    
    func getBestDuration() -> String {
        return Double(streak.best.duration).formatSecondDuration(maxUnit: .hour)
    }
    
    func getCurrentDate() -> String {
        return String(format: "dk_achievements_streaks_since".dkAchievementLocalized(), streak.current.startDate.format(pattern: .standardDate))
    }
    
    func getBestDates() -> String {
        return String(format: "dk_achievements_streaks_since_to".dkAchievementLocalized(), streak.best.startDate.format(pattern: .standardDate), streak.best.endDate.format(pattern: .standardDate))
    }
}

enum StreakStatus {
    case initialization, inProgress, best, reset
}
