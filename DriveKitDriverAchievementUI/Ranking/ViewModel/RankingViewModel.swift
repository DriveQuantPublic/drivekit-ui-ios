// swiftlint:disable all
//
//  RankingViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBAchievementAccessModule
import DriveKitDriverAchievementModule
import UIKit

class RankingViewModel {
    var selectedRankingType: RankingType? {
        didSet {
            update(allowEmptyPseudo: false)
        }
    }
    var selectedRankingSelector: RankingSelector? {
        didSet {
            update(allowEmptyPseudo: false)
        }
    }
    weak var delegate: RankingViewModelDelegate?
    private(set) var status: RankingStatus = .needsUpdate
    private(set) var ranks = [DKDriverRankingItem]()
    private(set) var driverRank: CurrentDriverRank?
    private(set) var rankingTypes = [RankingType]()
    private(set) var rankingSelectors = [RankingSelector]()
    private(set) var nbDrivers = 0
    private let groupName: String?
    private let dkRankingTypes: [DKRankingType]
    private let dkRankingSelectorType: DKRankingSelectorType
    private let rankingDepth: Int
    private var useCache = [String: Bool]()
    private var initialized = false
    private var progressionImageName: String?
    private var askForPseudoIfEmpty = true

    init(groupName: String?) {
        self.groupName = groupName
        self.dkRankingTypes = RankingViewModel.sanitizeRankingTypes(DriveKitDriverAchievementUI.shared.rankingTypes)
        for (index, rankingType) in self.dkRankingTypes.enumerated() {
            switch rankingType {
                case .distraction:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.distraction.text(), image: DKImages.distractionFlat.image))
                case .ecoDriving:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.ecodriving.text(), image: DKImages.ecoDrivingFlat.image))
                case .safety:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.safety.text(), image: DKImages.safetyFlat.image))
                case .speeding:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.speeding.text(), image: DKImages.speedingFlat.image))
                @unknown default:
                    break
            }
        }
        self.selectedRankingType = self.rankingTypes.first

        self.dkRankingSelectorType = RankingViewModel.sanitizeRankingSelectorType(DriveKitDriverAchievementUI.shared.rankingSelector)
        switch self.dkRankingSelectorType {
            case .none:
                break
            case let .period(rankingPeriods):
                for (index, rankingPeriod) in rankingPeriods.enumerated() {
                    let titleKey: String
                    switch rankingPeriod {
                        case .weekly:
                            titleKey = "dk_achievements_ranking_week"
                        case .legacy:
                            titleKey = "dk_achievements_ranking_legacy"
                        case .monthly:
                            titleKey = "dk_achievements_ranking_month"
                        case .allTime:
                            titleKey = "dk_achievements_ranking_permanent"
                        @unknown default:
                            titleKey = ""
                    }
                    self.rankingSelectors.append(RankingSelector(index: index, title: titleKey.dkAchievementLocalized()))
                }
        }
        self.selectedRankingSelector = self.rankingSelectors.first

        let rankingDepth = DriveKitDriverAchievementUI.shared.rankingDepth
        self.rankingDepth = rankingDepth > 0 ? rankingDepth : 5

        self.initialized = true
    }

    func update(allowEmptyPseudo: Bool) {
        if self.initialized {
            self.status = .updating

            if allowEmptyPseudo || !self.askForPseudoIfEmpty {
                self.updateRanking()
            } else {
                DriveKit.shared.getUserInfo(synchronizationType: .cache) { [weak self] _, userInfo in
                    if let self = self {
                        DispatchQueue.main.async { [weak self] in
                            if let self = self {
                                if self.askForPseudoIfEmpty && (userInfo?.pseudo?.isCompletelyEmpty() ?? true) {
                                    self.delegate?.updateUserPseudo()
                                    self.askForPseudoIfEmpty = false
                                } else {
                                    self.updateRanking()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func clearCache() {
        self.useCache.removeAll()
    }

    private func updateRanking() {
        let dkRankingType: DKRankingType
        let rankingTypeIndex = self.selectedRankingType?.index ?? 0
        if rankingTypeIndex < self.dkRankingTypes.count {
            dkRankingType = self.dkRankingTypes[rankingTypeIndex]
        } else {
            dkRankingType = self.dkRankingTypes.first ?? .safety
        }

        let dkRankingPeriod: DKRankingPeriod = getRankingPeriod()
        self.delegate?.rankingDidUpdate()

        let useCacheKey = "\(dkRankingType.rawValue)-\(dkRankingPeriod.rawValue)"
        let synchronizationType: SynchronizationType = self.useCache[useCacheKey] == true ? .cache : .defaultSync
        DriveKitDriverAchievement.shared.getRanking(rankingType: dkRankingType, rankingPeriod: dkRankingPeriod, rankingDepth: self.rankingDepth, groupName: self.groupName, type: synchronizationType) { [weak self] (rankingSyncStatus, ranking) in
            DispatchQueue.main.async {
                if let self = self {
                    self.driverRank = nil
                    if let ranking = ranking {
                        var ranks = [DKDriverRankingItem]()
                        let nbDrivers = ranking.nbDriverRanked
                        self.nbDrivers = nbDrivers
                        var previousRank: Int?
                        for dkRank in ranking.driversRanked.sorted(by: { (dkDriverRank1, dkDriverRank2) -> Bool in
                            if dkDriverRank2.rank == 0 {
                                return true
                            } else if dkDriverRank1.rank == 0 {
                                return false
                            } else {
                                return dkDriverRank1.rank <= dkDriverRank2.rank
                            }
                        }) {
                            if let previousRank = previousRank, previousRank + 1 != dkRank.rank {
                                ranks.append(JumpDriverRank())
                            }
                            let name: String
                            if let nickname = dkRank.nickname, !nickname.isEmpty {
                                name = nickname
                            } else {
                                name = DKCommonLocalizable.anonymous.text()
                            }
                            if dkRank.rank == ranking.userPosition {
                                let progressionImageName: String?
                                if let userPreviousPosition = ranking.userPreviousPosition, ranking.userPosition > 0 {
                                    let deltaRank = userPreviousPosition - ranking.userPosition
                                    if deltaRank == 0 {
                                        progressionImageName = nil
                                    } else if deltaRank > 0 {
                                        progressionImageName = "dk_common_ranking_arrow_up"
                                    } else {
                                        progressionImageName = "dk_common_ranking_arrow_down"
                                    }
                                } else {
                                    progressionImageName = nil
                                }
                                self.progressionImageName = progressionImageName
                                let currentDriverRank = CurrentDriverRank(
                                    nbDrivers: nbDrivers,
                                    position: dkRank.rank,
                                    positionString: String(dkRank.rank),
                                    positionImageName: self.getImageName(fromPosition: dkRank.rank),
                                    rankString: " / \(nbDrivers)",
                                    name: name,
                                    distance: dkRank.distance,
                                    distanceString: dkRank.distance.formatKilometerDistance(),
                                    score: dkRank.score,
                                    scoreString: self.formatScore(dkRank.score),
                                    totalScoreString: " / 10"
                                )
                                ranks.append(currentDriverRank)
                                self.driverRank = currentDriverRank
                            } else {
                                let driverRank = DriverRank(
                                    nbDrivers: nbDrivers,
                                    position: dkRank.rank,
                                    positionString: String(dkRank.rank),
                                    positionImageName: self.getImageName(fromPosition: dkRank.rank),
                                    rankString: " / \(nbDrivers)",
                                    name: name,
                                    distance: dkRank.distance,
                                    distanceString: dkRank.distance.formatKilometerDistance(),
                                    score: dkRank.score,
                                    scoreString: self.formatScore(dkRank.score),
                                    totalScoreString: " / 10"
                                )
                                ranks.append(driverRank)
                            }
                            previousRank = dkRank.rank
                        }
                        self.ranks = ranks
                    } else {
                        self.nbDrivers = 0
                        self.ranks = []
                    }

                    switch rankingSyncStatus {
                        case .noError:
                            self.status = .success
                        case .userNotRanked:
                            self.status = .noRankForUser
                        case .cacheDataOnly, .failedToSyncRanking, .syncAlreadyInProgress:
                            if ranking != nil {
                                self.status = .success
                            } else {
                                self.status = .networkError
                            }
                        @unknown default:
                            break
                    }

                    let dataError: Bool
                    switch rankingSyncStatus {
                        case .noError, .userNotRanked:
                            dataError = false
                        case .failedToSyncRanking, .syncAlreadyInProgress, .cacheDataOnly:
                            dataError = true
                        @unknown default:
                            dataError = true
                    }
                    self.useCache[useCacheKey] = !dataError

                    self.delegate?.rankingDidUpdate()
                }
            }
        }
    }

    private func getRankingPeriod() -> DKRankingPeriod {
        let dkRankingPeriod: DKRankingPeriod
        switch self.dkRankingSelectorType {
            case .none:
                dkRankingPeriod = .weekly
            case let .period(rankingPeriods):
                let periodIndex = self.selectedRankingSelector?.index ?? 0
                if periodIndex < rankingPeriods.count {
                    dkRankingPeriod = rankingPeriods[periodIndex]
                } else {
                    dkRankingPeriod = rankingPeriods.first ?? .weekly
                }
            }
        return dkRankingPeriod
    }

    private func getImageName(fromPosition position: Int) -> String? {
        if position >= 1 && position <= 3 {
            return "dk_common_rank_\(position)"
        } else {
            return nil
        }
    }

    private func formatScore(_ score: Double) -> String {
        if score.round(places: 2) >= 10 {
            return "10"
        } else if score.round(places: 2) == score.round(places: 0) {
            return score.formatDouble(places: 0)
        } else {
            return score.formatDouble(fractionDigits: 2)
        }
    }

    private static func sanitizeRankingTypes(_ rankingTypes: [DKRankingType]) -> [DKRankingType] {
        if rankingTypes.isEmpty {
            return [.safety]
        } else {
            var filteredRankingTypes = [DKRankingType]()
            var rankingTypesSet: Set<DKRankingType> = []
            for rankingType in rankingTypes {
                if !rankingTypesSet.contains(rankingType) && rankingType.hasAccess() {
                    filteredRankingTypes.append(rankingType)
                    rankingTypesSet.insert(rankingType)
                }
            }
            return filteredRankingTypes
        }
    }

    private static func sanitizeRankingSelectorType(_ selectorType: DKRankingSelectorType) -> DKRankingSelectorType {
        switch selectorType {
            case .none:
                return selectorType
            case let .period(rankingPeriods):
                return .period(rankingPeriods: sanitizePeriods(rankingPeriods))
        }
    }

    private static func sanitizePeriods(_ rankingPeriods: [DKRankingPeriod]) -> [DKRankingPeriod] {
        if rankingPeriods.isEmpty {
            return [.weekly]
        } else {
            var filteredRankingPeriods = [DKRankingPeriod]()
            var rankingPeriodsSet: Set<DKRankingPeriod> = []
            let managedRankingPeriods: Set<DKRankingPeriod> = Set(DKRankingPeriod.allCases)
            for rankingPeriod in rankingPeriods {
                if !rankingPeriodsSet.contains(rankingPeriod) && managedRankingPeriods.contains(rankingPeriod) {
                    filteredRankingPeriods.append(rankingPeriod)
                    rankingPeriodsSet.insert(rankingPeriod)
                }
            }
            return filteredRankingPeriods
        }
    }

}

extension DKRankingType {
    func hasAccess() -> Bool {
        let driveKitAccess = DriveKitAccess.shared
        switch self {
            case .distraction:
                return driveKitAccess.hasAccess(.phoneDistraction)
            case .ecoDriving:
                return driveKitAccess.hasAccess(.ecoDriving)
            case .safety:
                return driveKitAccess.hasAccess(.safety)
            case .speeding:
                return driveKitAccess.hasAccess(.speeding)
            @unknown default:
                return false
        }
    }
}

protocol RankingViewModelDelegate: AnyObject {
    func rankingDidUpdate()
    func updateUserPseudo()
}

extension RankingViewModel: DKDriverRanking {
    func getHeaderDisplayType() -> DKRankingHeaderDisplayType {
        if rankingSelectors.count > 1 {
            return .compact
        } else {
            return .full
        }
    }

    func getDriverRankingItems() -> [DKDriverRankingItem] {
        return ranks
    }

    func getTitle() -> String {
        guard !rankingSelectors.isEmpty else {
            return ""
        }
        return selectedRankingType?.name ?? DKCommonLocalizable.safety.text()
    }

    func getImage() -> UIImage? {
        guard !rankingSelectors.isEmpty else {
            return nil
        }
        return selectedRankingType?.image ?? DKImages.safetyFlat.image
    }

    func getProgressionImage() -> UIImage? {
        if let progressionImageName = self.progressionImageName {
            return UIImage(named: progressionImageName, in: Bundle.driveKitCommonUIBundle, compatibleWith: nil)
        } else {
            return nil
        }
    }

    func getDriverGlobalRankAttributedText() -> NSAttributedString {
        if let driverRank = driverRank {
            let driverRankString = driverRank.positionString.dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = driverRank.rankString.dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            return "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)
        } else {
            let driverRankString = "-".dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = " / \(nbDrivers)".dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            return "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)
        }
    }

    func getScoreTitle() -> String {
        return DKCommonLocalizable.rankingScore.text()
    }

    func hasInfoButton() -> Bool {
        return true
    }

    func infoPopupTitle() -> String? {
        return ""
    }

    func infoPopupMessage() -> String? {
        let dkRankingPeriod: DKRankingPeriod = getRankingPeriod()

        switch dkRankingPeriod {
        case .weekly:
            return "dk_achievements_ranking_week_info".dkAchievementLocalized()
        case .monthly:
            return "dk_achievements_ranking_month_info".dkAchievementLocalized()
        case .allTime:
            return "dk_achievements_ranking_permanent_info".dkAchievementLocalized()
        case .legacy:
            return "dk_achievements_ranking_legacy_info".dkAchievementLocalized()
        @unknown default:
            return nil
        }
    }
}
