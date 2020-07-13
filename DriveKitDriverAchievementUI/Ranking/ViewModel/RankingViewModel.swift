//
//  RankingViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 06/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitCommonUI
import DriveKitDBAchievementAccess
import DriveKitDriverAchievement

class RankingViewModel {

    var selectedRankingType: RankingType? {
        didSet {
            update()
        }
    }
    var selectedRankingSelector: RankingSelector? {
        didSet {
            update()
        }
    }
    weak var delegate: RankingViewModelDelegate? = nil
    private(set) var status: RankingStatus = .needsUpdate
    private(set) var ranks = [AnyDriverRank]()
    private(set) var driverRank: CurrentDriverRank? = nil
    private(set) var rankingTypes = [RankingType]()
    private(set) var rankingSelectors = [RankingSelector]()
    private let dkRankingTypes: [DKRankingType]
    private let dkRankingSelectorType: DKRankingSelectorType
    private var initialized = false


    init() {
        self.dkRankingTypes = RankingViewModel.sanitizeRankingTypes(DriveKitDriverAchievementUI.shared.rankingTypes)
        for (index, rankingType) in self.dkRankingTypes.enumerated() {
            switch rankingType {
                case .distraction:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.distraction.text(), imageName: "dk_achievements_ranking_phone_distraction"))
                case .ecoDriving:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.ecodriving.text(), imageName: "dk_achievements_ranking_ecodriving"))
                case .safety:
                    self.rankingTypes.append(RankingType(index: index, name: DKCommonLocalizable.safety.text(), imageName: "dk_achievements_ranking_safety"))
            }
        }
        self.selectedRankingType = self.rankingTypes.first

        self.dkRankingSelectorType = RankingViewModel.sanitizeRankingSelectorType(DriveKitDriverAchievementUI.shared.rankingSelector)
        switch self.dkRankingSelectorType {
            case .none:
                break
            case let .period(rankingPeriods):
                for (index, rankingPeriod) in rankingPeriods.enumerated() {
                    let nbDays: Int
                    switch rankingPeriod {
                        case .weekly:
                            nbDays = 7
                        case .legacy:
                            nbDays = 14
                        case .monthly:
                            nbDays = 30
                    }
                    self.rankingSelectors.append(RankingSelector(index: index, title: "\(nbDays) \("dk_achievements_ranking_days".dkAchievementLocalized())"))
                }
        }
        self.selectedRankingSelector = self.rankingSelectors.first

        self.initialized = true
    }

    func update() {
        if self.initialized {
            self.status = .updating

            let dkRankingType: DKRankingType
            let rankingTypeIndex = self.selectedRankingType?.index ?? 0
            if rankingTypeIndex < self.dkRankingTypes.count {
                dkRankingType = self.dkRankingTypes[rankingTypeIndex]
            } else {
                dkRankingType = self.dkRankingTypes.first ?? .safety
            }

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

            DriveKitDriverAchievement.shared.getRanking(rankingType: dkRankingType, rankingPeriod: dkRankingPeriod) { [weak self] (rankingSyncStatus, ranking) in
                DispatchQueue.main.async {
                    if let self = self {
                        self.driverRank = nil
                        if let ranking = ranking {
                            var ranks = [AnyDriverRank]()
                            let nbDrivers = ranking.nbDriverRanked
                            for dkRank in ranking.driversRanked.sorted(by: { (dkDriverRank1, dkDriverRank2) -> Bool in
                                if dkDriverRank2.rank == 0 {
                                    return true
                                } else if dkDriverRank1.rank == 0 {
                                    return false
                                } else {
                                    return dkDriverRank1.rank <= dkDriverRank2.rank
                                }
                            }) {
                                let driverRank = DriverRank(
                                    nbDrivers: nbDrivers,
                                    position: dkRank.rank,
                                    positionString: String(dkRank.rank),
                                    positionImageName: self.getImageName(fromPosition: dkRank.rank),
                                    rankString: " / \(nbDrivers)",
                                    name: dkRank.nickname ?? "-",
                                    distance: dkRank.distance,
                                    distanceString: dkRank.distance.formatMeterDistance(),
                                    score: dkRank.score,
                                    scoreString: self.formatScore(dkRank.score),
                                    totalScoreString: " / 10"
                                )
                                if dkRank.rank == ranking.userPosition {
                                    #warning("TODO")
                                    let currentDriverRank = CurrentDriverRank(driverRank: driverRank, progressionImageName: nil)
                                    ranks.append(currentDriverRank)
                                    self.driverRank = currentDriverRank
                                } else {
                                    ranks.append(driverRank)
                                }
                            }
                            self.ranks = ranks
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
                        }

                        self.delegate?.rankingDidUpdate()
                    }
                }
            }
        }
    }

    private func getImageName(fromPosition position: Int) -> String? {
        if position >= 1 && position <= 3 {
            return "dk_achievements_ranking_rank_\(position)"
        } else {
            return nil
        }
    }

    private func formatScore(_ score: Double) -> String {
        if score >= 10 {
            return "10"
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
            let managedRankingTypes: Set<DKRankingType> = Set(DKRankingType.allCases)
            for rankingType in rankingTypes {
                if !rankingTypesSet.contains(rankingType) && managedRankingTypes.contains(rankingType) {
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


protocol RankingViewModelDelegate : AnyObject {
    func rankingDidUpdate()
}
