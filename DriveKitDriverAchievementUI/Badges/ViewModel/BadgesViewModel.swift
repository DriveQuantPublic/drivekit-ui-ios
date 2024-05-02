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

    private var badgeStatistics: DKBadgeStatistics {
        DriveKitDriverAchievement.shared.getBadgeStatistics()
    }

    func darkColorForLevel(_ level: DKLevel) -> UIColor {
        // swiftlint:disable no_magic_numbers
        switch level {
            case .bronze:
                return UIColor(hex: 0xc16955)
            case .silver:
                return UIColor(hex: 0x858681)
            case .gold:
                return UIColor(hex: 0xb4831f)
        }
        // swiftlint:enable no_magic_numbers
    }

    private func levelName(_ level: DKLevel) -> String {
        switch level {
            case .bronze:
                return "dk_badge_bronze".dkAchievementLocalized()
            case .silver:
                return "dk_badge_silver".dkAchievementLocalized()
            case .gold:
                return "dk_badge_gold".dkAchievementLocalized()
        }
    }

    private func levelCount(_ level: DKLevel) -> String {
        let badgeStats = self.badgeStatistics
        switch level {
            case .bronze:
                return "\(badgeStats.acquiredBronze)/\(badgeStats.totalBronze)"
            case .silver:
                return "\(badgeStats.acquiredSilver)/\(badgeStats.totalSilver)"
            case .gold:
                return "\(badgeStats.acquiredGold)/\(badgeStats.totalGold)"
        }
    }

    func attributedTextForLevel(_ level: DKLevel) -> NSAttributedString {
        let color = darkColorForLevel(level)
        let levelAttributedString = levelName(level)
            .dkAttributedString()
            .center()
        // swiftlint:disable:next no_magic_numbers
            .font(dkFont: .primary, style: DKStyles.smallText.withSizeDelta(-2))
            .color(color)
            .build()
        let countAttributedString = levelCount(level)
            .dkAttributedString()
            .center()
            .font(dkFont: .primary, style: .highlightSmall)
            .color(color)
            .build()
        return "%@\n%@".dkAttributedString().buildWithArgs(levelAttributedString, countAttributedString)
    }

    func attributedTextForTotalCount() -> NSAttributedString {
        let badgeStats = self.badgeStatistics

        let textKey = badgeStats.acquired > 1 ? "dk_badge_earned_badges_number_title_plural" : "dk_badge_earned_badges_number_title_singular"
        
        let countAttributedText = "\(badgeStats.acquired)"
            .dkAttributedString()
            .font(dkFont: .primary, style: .highlightNormal)
            .color(.primaryColor)
            .build()

        return textKey
            .dkAchievementLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.primaryColor)
            .buildWithArgs(countAttributedText, specifier: "%d")
    }
}

protocol BadgeDelegate: AnyObject {
    func badgesUpdated()
}
