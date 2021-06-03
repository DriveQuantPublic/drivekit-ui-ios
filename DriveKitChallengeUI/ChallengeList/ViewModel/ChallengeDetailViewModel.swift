//
//  ChallengeDetailViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule
import DriveKitDBChallengeAccessModule

protocol ChallengeDetailViewModelDelegate {
    func didSelectTrip(tripId: String)
}

class ChallengeDetailViewModel {
    private let challenge: DKChallenge
    private let challengeDetail: DKChallengeDetail
    private let challengeType: ChallengeType
    private let challengeTheme: ChallengeTheme
    private let sortedTrips: [DKTripsByDate]
    private(set) var ranks = [ChallengeDriverRank]()
    private(set) var nbDrivers = 0
    public var delegate: ChallengeDetailViewModelDelegate?

    init(challenge: DKChallenge, challengeDetail: DKChallengeDetail) {
        self.challenge = challenge
        self.challengeDetail = challengeDetail
        switch challenge.themeCode {
        case 101, 102, 103, 104 :
            self.challengeType = .score
            self.challengeTheme = .ecoDriving
        case 201, 202, 203, 204:
            self.challengeType = .score
            self.challengeTheme = .safety
        case 205, 206, 207, 208:
            self.challengeType = .score
            self.challengeTheme = .braking
        case 209, 210, 211, 212:
            self.challengeType = .score
            self.challengeTheme = .acceleration
        case 213, 214, 215, 216:
            self.challengeType = .score
            self.challengeTheme = .adherence
        case 221:
            self.challengeType = .score
            self.challengeTheme = .distraction
        case 301:
            self.challengeType = .nbTrips
            self.challengeTheme = .none
        case 302, 303, 304, 305:
            self.challengeType = .distance
            self.challengeTheme = .none
        case 306, 307, 308, 309:
            self.challengeType = .duration
            self.challengeTheme = .none
        default:
            self.challengeType = .distance
            self.challengeTheme = .none
        }
        let sortedTrips = DriveKitDBTripAccess.shared.findTrips(itinIds: challengeDetail.itinIds).map({trip in
            return ChallengeTrip(trip: trip)
        }).orderByDay(descOrder: true)
        self.sortedTrips = sortedTrips
        self.ranks = challengeDetail.driverRanked
            .sorted(by: { $0.rank < $1.rank })
            .map({driverRanked in
                let name: String
                if let nickname = driverRanked.nickname, !nickname.isEmpty {
                    name = nickname
                } else {
                    name = DKCommonLocalizable.anonymous.text()
                }
                if driverRanked.rank == challengeDetail.userIndex {
                    return CurrentChallengeDriverRank(nbDrivers: challengeDetail.nbDriverRanked,
                                               position: driverRanked.rank,
                                               positionString: String(driverRanked.rank),
                                               positionImageName: self.getImageName(fromPosition: driverRanked.rank),
                                               rankString: " / \(challengeDetail.nbDriverRanked)",
                                               name: name,
                                               distance: driverRanked.distance,
                                               distanceString: driverRanked.distance.formatKilometerDistance(),
                                               score: driverRanked.score,
                                               scoreString: self.formatScore(driverRanked.score),
                                               totalScoreString: " / 10")
                } else {
                    return ChallengeDriverRank(nbDrivers: challengeDetail.nbDriverRanked,
                                               position: driverRanked.rank,
                                               positionString: String(driverRanked.rank),
                                               positionImageName: self.getImageName(fromPosition: driverRanked.rank),
                                               rankString: " / \(challengeDetail.nbDriverRanked)",
                                               name: name,
                                               distance: driverRanked.distance,
                                               distanceString: driverRanked.distance.formatKilometerDistance(),
                                               score: driverRanked.score,
                                               scoreString: self.formatScore(driverRanked.score),
                                               totalScoreString: " / 10")
                }
            
        })
    }

    func getResultsViewModel() -> ChallengeResultsViewModel {
        return ChallengeResultsViewModel(challengeDetail: challengeDetail, challengeType: challengeType, challengeTheme: challengeTheme)
    }
    func getRankingViewModel() -> DKDriverRankingViewModel {
        return DKDriverRankingViewModel(ranking: self)
    }
    func getTripListViewModel() -> DKTripListViewModel {
        return DKTripListViewModel(tripList: self)
    }
    func getRulesViewModel() -> ChallengeParticipationViewModel {
        return ChallengeParticipationViewModel(challenge: challenge, isRulesTab: true)
    }

    private func formatScore(_ score: Double) -> String {
        if score >= 10 {
            return "10"
        } else {
            return score.formatDouble(fractionDigits: 2)
        }
    }

    private func getImageName(fromPosition position: Int) -> String? {
        if position >= 1 && position <= 3 {
            return "dk_common_rank_\(position)"
        } else {
            return nil
        }
    }

    func getChallengeName() -> String {
        return challenge.title
    }
}

extension ChallengeDetailViewModel: DKTripList {
    func didSelectTrip(itinId: String) {
        self.delegate?.didSelectTrip(tripId: itinId)
    }

    func getTripData() -> TripData {
        switch challengeType {
        case .score:
            switch challengeTheme {
            case .ecoDriving:
                return .ecoDriving
            case .adherence, .braking, .acceleration, .safety:
                return .safety
            case .distraction:
                return .distraction
            default:
                return .safety
            }
        case .distance:
            return .distance
        case .duration:
            return .duration
            // TODO: What about nbTrip case? add new value to TripData enum?
        default:
            return .distance
        }
    }

    func getTripsList() -> [DKTripsByDate] {
        return self.sortedTrips
    }

    func getCustomHeader() -> DKHeader? {
        return nil
    }

    func getHeaderDay() -> HeaderDay {
        return .durationDistance
    }

    func canPullToRefresh() -> Bool {
        return false
    }

    func didPullToRefresh() {
    }
}

extension ChallengeDetailViewModel: DKDriverRanking {
    // TODO: correct implmeentation with accurate values
    func getHeaderDisplayType() -> DKRankingHeaderDisplayType {
        return .full
    }

    func getDriverRankingItems() -> [DKDriverRankingItem] {
        return ranks
    }

    func getTitle() -> String {
        if challengeType == .score {
            return challengeTheme.scoreTitle
        } else {
            return challengeType.overviewTitle
        }
    }

    func getImage() -> UIImage? {
        var imageName: String? = nil
        switch challengeTheme {
        case .acceleration, .adherence, .braking, .safety:
            imageName = "dk_challenge_leaderboard_safety"
            break
        case .distraction:
            imageName = "dk_challenge_leaderboard_phone_distraction"
            break
        case .ecoDriving:
            imageName = "dk_challenge_leaderboard_ecodriving"
            break
        case .none:
            switch challengeType {
            case .distance:
                imageName = "dk_challenge_leaderboard_distance"
                break
            case .duration:
                imageName = "dk_challenge_leaderboard_duration"
                break
            case .nbTrips:
                imageName = "dk_challenge_leaderboard_trips_number"
                break
            default:
                imageName = "dk_challenge_leaderboard_safety"
                break
            }
        }
        if let imageName = imageName {
            return UIImage(named: imageName, in: Bundle.challengeUIBundle, compatibleWith: nil)
        } else {
            return nil
        }
    }

    func getProgressionImage() -> UIImage? {
        return nil
    }

    func getDriverGlobalRankAttributedText() -> NSAttributedString {
        if challengeDetail.userIndex > 0, challengeDetail.userIndex <= ranks.count {
            let driverRank = ranks[challengeDetail.userIndex-1]
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
        switch challengeType {
        case .score:
            return DKCommonLocalizable.rankingScore.text()
        case .distance:
            return DKCommonLocalizable.distance.text()
        case .duration:
            return DKCommonLocalizable.duration.text()
        case .nbTrips:
            return DKCommonLocalizable.tripPlural.text().capitalizeFirstLetter()
        }
    }
}
