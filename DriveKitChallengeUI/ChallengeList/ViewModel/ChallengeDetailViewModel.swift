// swiftlint:disable no_magic_numbers
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
import DriveKitChallengeModule
import UIKit

protocol ChallengeDetailViewModelDelegate: AnyObject {
    func didSelectTrip(tripId: String, showAdvice: Bool)
    func didUpdateChallengeDetails()
}

class ChallengeDetailViewModel {
    private let challenge: DKChallenge
    private var challengeDetail: DKChallengeDetail
    private let challengeType: DKChallengeType
    private var sortedTrips: [DKTripsByDate] = []
    private(set) var ranks = [ChallengeDriverRank]()
    private(set) var nbDrivers = 0
    public weak var delegate: ChallengeDetailViewModelDelegate?
    private var resultsViewModel: ChallengeResultsViewModel?

    init(challenge: DKChallenge, challengeDetail: DKChallengeDetail) {
        self.challenge = challenge
        self.challengeDetail = challengeDetail
        self.challengeType = challenge.challengeType
        updateTripsAndRanks()
    }

    func updateTripsAndRanks() {
        let sortedTrips = DriveKitDBTripAccess.shared.findTrips(itinIds: challengeDetail.itinIds).map({trip in
            return ChallengeTrip(trip: trip)
        }).sorted(by: { trip1, trip2 in
            return trip1.getEndDate() <= trip2.getEndDate()
        }).orderByDay(descOrder: true)
        self.sortedTrips = sortedTrips
        self.ranks = challengeDetail.driverRanked
            .sorted(by: { $0.rank < $1.rank })
            .map({driverRanked in
                let name: String
                if let pseudo = driverRanked.pseudo, !pseudo.isEmpty {
                    name = pseudo
                } else {
                    name = DKCommonLocalizable.anonymous.text()
                }
                let scoreString: String
                let totalScoreString: String
                scoreString = self.formatScore(driverRanked.score)
                totalScoreString = " / 10"
                if driverRanked.rank == challengeDetail.userIndex {
                    return CurrentChallengeDriverRank(
                        nbDrivers: challengeDetail.nbDriverRegistered,
                        position: driverRanked.rank,
                        positionString: String(driverRanked.rank),
                        positionImageName: self.getImageName(fromPosition: driverRanked.rank),
                        rankString: " / \(challengeDetail.nbDriverRanked)",
                        name: name,
                        distance: driverRanked.distance,
                        distanceString: driverRanked.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10),
                        score: driverRanked.score,
                        scoreString: scoreString,
                        totalScoreString: totalScoreString
                    )
                } else {
                    return ChallengeDriverRank(nbDrivers: challengeDetail.nbDriverRegistered,
                                               position: driverRanked.rank,
                                               positionString: String(driverRanked.rank),
                                               positionImageName: self.getImageName(fromPosition: driverRanked.rank),
                                               rankString: " / \(challengeDetail.nbDriverRanked)",
                                               name: name,
                                               distance: driverRanked.distance,
                                               distanceString: driverRanked.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10),
                                               score: driverRanked.score,
                                               scoreString: scoreString,
                                               totalScoreString: totalScoreString)
                }
            
        })
    }

    func getResultsViewModel() -> ChallengeResultsViewModel {
        let resultsVM = ChallengeResultsViewModel(challengeDetail: challengeDetail, challengeType: challengeType)
        self.resultsViewModel = resultsVM
        return resultsVM
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

    func updateChallengeDetail() {
        DriveKitChallenge.shared.getChallengeDetail(challengeId: challenge.id, type: .defaultSync) { [weak self] _, challengeDetail in
            if let challengeDetail = challengeDetail {
                self?.challengeDetail = challengeDetail
                self?.resultsViewModel?.update(challengeDetail: challengeDetail)
                self?.updateTripsAndRanks()
            }
            self?.delegate?.didUpdateChallengeDetails()
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

    func getTitleAttributedString() -> NSAttributedString {
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = .center
        let titleAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold),
            NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color,
            NSAttributedString.Key.paragraphStyle: alignment
        ]
        let titleString = challenge.title
        return NSAttributedString(string: titleString, attributes: titleAttributes)
    }

    func getDateAttributedString() -> NSAttributedString {
        return ChallengeItemViewModel.formatStartAndEndDates(
            startDate: challenge.startDate,
            endDate: challenge.endDate,
            tintColor: DKUIColors.complementaryFontColor.color,
            alignment: .center
        )
    }
}

extension ChallengeDetailViewModel: DKTripList {
    func didSelectTrip(itinId: String) {
        self.delegate?.didSelectTrip(tripId: itinId, showAdvice: false)
    }

    func getTripData() -> TripData {
        switch challengeType {
            case .safety, .hardBraking, .hardAcceleration:
                return .safety
            case .ecoDriving:
                return .ecoDriving
            case .distraction:
                return .distraction
            case .speeding:
                return .speeding
            case .deprecated, .unknown:
                return .safety
            @unknown default:
                return .safety
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
    func getHeaderDisplayType() -> DKRankingHeaderDisplayType {
        return .full
    }

    func getDriverRankingItems() -> [DKDriverRankingItem] {
        return ranks
    }

    func getTitle() -> String {
        return challengeType.scoreTitle
    }

    func getImage() -> UIImage? {
        switch challengeType {
        case .hardAcceleration, .hardBraking, .safety:
            return DKChallengeImages.leaderboardSafety.image
        case .distraction:
            return DKChallengeImages.leaderboardDistraction.image
        case .ecoDriving:
            return DKChallengeImages.leaderboardEcodriving.image
        case .speeding:
            return DKChallengeImages.leaderboardSpeeding.image
        case .deprecated, .unknown:
            return nil
        @unknown default:
            return nil
        }
    }

    func getProgressionImage() -> UIImage? {
        return nil
    }

    func getDriverGlobalRankAttributedText() -> NSAttributedString {
        if challengeDetail.userIndex > 0, challengeDetail.userIndex <= challengeDetail.nbDriverRanked {
            let driverRankString = String(challengeDetail.userIndex).dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = " / \(challengeDetail.nbDriverRegistered)".dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            return "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)
        } else {
            let driverRankString = "-".dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.secondaryColor).build()
            let rankString = " / \(challengeDetail.nbDriverRegistered)".dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()
            return "%@%@".dkAttributedString().buildWithArgs(driverRankString, rankString)
        }
    }

    func getScoreTitle() -> String {
        return DKCommonLocalizable.rankingScore.text()
    }

    func hasInfoButton() -> Bool {
        return false
    }

    func infoPopupTitle() -> String? {
        return nil
    }

    func infoPopupMessage() -> String? {
        return nil
    }
}
