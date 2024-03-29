//
//  BadgesViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverAchievementModule
import DriveKitDBAchievementAccessModule
import UIKit
import DriveKitCommonUI

class BadgeViewModel {
    weak var delegate: BadgeDelegate?
    private var badges: [DKBadge] = []
    private(set) var updating: Bool = false

    init() {
        let badges = DriveKitDBAchievementAccess.shared.badgesQuery().noFilter().query().execute()
        self.badges = self.computeBadges(badges)
    }
    
    func updateBadges() {
        self.updating = true
        DriveKitDriverAchievement.shared.getBadges { [weak self] _, badges, _ in
            DispatchQueue.main.async {
                if let self = self {
                    self.updating = false
                    self.badges = self.computeBadges(badges)
                    self.delegate?.badgesUpdated()
                }
            }
        }
    }
    
    private func computeBadges(_ badges: [DKBadge]) -> [DKBadge] {
        var result: [DKBadge] = []
        for configuredBadge in DriveKitDriverAchievementUI.shared.badgeCategories {
            let badge = badges.filter { configuredBadge == $0.category }
            result.append(contentsOf: badge)
        }
        return result
    }
    
    var badgesCount: Int {
        return badges.count
    }
    
    func badgeTitle(pos: Int) -> String {
        return badges[pos].theme.dkAchievementLocalized()
    }
    
    func badgeLevels(pos: Int) -> [DKBadgeCharacteristics] {
        return badges[pos].badgeCharacteristics
    }
}

protocol BadgeDelegate: AnyObject {
    func badgesUpdated()
}
