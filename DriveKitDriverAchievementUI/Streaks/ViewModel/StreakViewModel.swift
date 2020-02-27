//
//  StreakViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 07/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverAchievement
import DriveKitDBAchievementAccess
import UIKit
import DriveKitCommonUI

class StreakViewModel {
    
    var delegate : StreakVMDelegate? = nil
    
    var streakData : [StreakData] = []
    
    init() {
    }
    
    func getStreakData() {
        DriveKitDriverAchievement.shared.getStreaks(completionHandler: {status, streaks in
            for streak in streaks {
                self.streakData.append(StreakData(streak: streak))
            }
            self.delegate?.streaksUpdated()
        })
    }
    
}

protocol StreakVMDelegate {
    func streaksUpdated()
}

struct StreakData {
    let type : StreakDataType
    let status : StreakStatus
    let streak : Streak
    let progressPercent : Int
    
    init(streak: Streak) {
        self.streak = streak
        self.type = StreakDataType.getEnumFromStreakTheme(theme: streak.theme!)
        if streak.best?.tripNumber == streak.current?.tripNumber {
            if streak.current?.tripNumber == 0 {
                status = .initialization
                progressPercent = 0
            }else{
                status = .best
                progressPercent = 100
            }
        }else{
            if streak.current?.tripNumber == 0 {
                status = .reset
                progressPercent = 0
            }else{
                status = .inProgress
                if let currentTripNumber = streak.current?.tripNumber, let bestTripNumber = streak.best?.tripNumber {
                    progressPercent = Int((Float(currentTripNumber) / Float(bestTripNumber)) * 100)
                }else{
                    progressPercent = 0
                }
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
        return "\(streak.current?.tripNumber ?? 0)"
    }
    
    func getCurrentTripNumberText() -> String {
        return getTripNumberText(tripNumber: streak.current?.tripNumber)
    }
    
    func getBestTripNumber() -> String {
        return "\(streak.best?.tripNumber ?? 0)"
    }
    
    func getBestTripNumberText() -> String {
        return getTripNumberText(tripNumber: self.streak.best?.tripNumber ?? 0)
    }
    
    private func getTripNumberText(tripNumber : Int32?) -> String {
        var tripsText = DKCommonLocalizable.tripSingular.text()
        if let tripNb = tripNumber, tripNb > 1 {
            tripsText = DKCommonLocalizable.tripPlural.text()
        }
        return tripsText
    }
    
    func getCurrentDistance() -> String {
        return getDistance(distance: streak.current?.distance ?? 0)
    }
    
    func getBestDistance() -> String {
        return getDistance(distance: streak.best?.distance ?? 0)
    }
    
    private func getDistance(distance: Double) -> String {
        return "\(Int(distance.metersToKilometers(places: 0))) \("dk_unit_km".dkAchievementLocalized())"
    }
    
    func getCurrentDuration() -> String {
        if let duration = streak.current?.duration {
            return Double(duration).secondToDayHourMinute()
        }else{
            return "0 \("dk_unit_minute".dkAchievementLocalized())"
        }
    }
    
    func getBestDuration() -> String {
        if let duration = streak.best?.duration {
            return Double(duration).secondToDayHourMinute()
        }else{
            return "0 \("dk_unit_minute".dkAchievementLocalized())"
        }
    }
    
    func getCurrentDate() -> String {
        if let date = streak.current?.startDate {
            return String(format: "dk_achievements_streaks_since".dkAchievementLocalized(), date.format(with: "dd/MM/yyyy"))
        }else{
            return String(format: "dk_achievements_streaks_since".dkAchievementLocalized(), Date().format(with: "dd/MM/yyyy"))
        }
    }
    
    func getBestDates() -> String {
        if let start = streak.best?.startDate, let end = streak.best?.endDate {
            return String(format: "dk_achievements_streaks_since_to".dkAchievementLocalized(), start.format(with: "dd/MM/yyyy"), end.format(with: "dd/MM/yyyy"))
        }else{
            return "dk_achievements_streaks_empty".dkAchievementLocalized()
        }
    }
}

enum StreakStatus {
    case initialization, inProgress, best, reset
}
