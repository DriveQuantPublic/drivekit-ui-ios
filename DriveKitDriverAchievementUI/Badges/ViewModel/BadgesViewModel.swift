//
//  BadgesViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverAchievement
import DriveKitDBAchievementAccess
import UIKit
import DriveKitCommonUI

class BadgeViewModel {
    
    weak var delegate : BadgeDelegate? = nil
    
    private var badges : [DKBadge] = []
    
    init() {
    }
    
    func updateBadges() {
        DriveKitDriverAchievement.shared.getBadges(completionHandler: {status, badges, newBadges in
            DispatchQueue.main.async {
                self.computeBadges(badges: badges)
                self.delegate?.badgesUpdated()
            }
        })
    }
    
    private func computeBadges(badges : [DKBadge]) {
        for configuredBadge in DriveKitDriverAchievementUI.shared.badgeCategories {
            let badge = (badges.filter { configuredBadge == $0.category })
            self.badges.append(contentsOf: badge)
        }
    }

    
    var badgesCount : Int {
        return badges.count
    }
    
    func badgeTitle(pos: Int) -> String {
        return badges[pos].theme.dkAchievementLocalized()
    }
    
    func badgeLevels(pos: Int) -> [DKBadgeCharacteristics] {
        return badges[pos].badgeCharacteristics
    }
}

protocol BadgeDelegate : AnyObject {
    func badgesUpdated()
}
