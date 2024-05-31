// swiftlint:disable no_magic_numbers
//
//  ChallengeResultsViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBChallengeAccessModule

class ChallengeResultsViewModel {
    private var challengeDetail: DKChallengeDetail
    let challengeType: DKChallengeType
    private let goldColor = UIColor(red: 255, green: 215, blue: 0)
    private let lightGoldColor = UIColor(red: 1, green: 215.0 / 255, blue: 0, alpha: 0.2)

    init(challengeDetail: DKChallengeDetail,
         challengeType: DKChallengeType = .safety) {
        self.challengeDetail = challengeDetail
        self.challengeType = challengeType
    }

    func update(challengeDetail: DKChallengeDetail) {
        self.challengeDetail = challengeDetail
    }

    func getDriverPseudo() -> String {
        let currentDriver = challengeDetail.driverRanked.first { driverRanked in
            driverRanked.rank == challengeDetail.userIndex
        }
        return currentDriver?.pseudo ?? ""
    }

    func getHeaderCellAttributedString() -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let titleMajorAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 44).with(.traitBold),
            NSAttributedString.Key.foregroundColor: DKUIColors.secondaryColor.color
        ]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 0.85

        let name = getDriverPseudo()
        let stringRank = String(challengeDetail.userIndex)

        let stringMaxRank = String(challengeDetail.nbDriverRegistered)
        
        let scoreHeaderString = "\n" + name + " "
        let headerAttributedString = NSMutableAttributedString(string: scoreHeaderString, attributes: titleAttributes)
        
        headerAttributedString.append(NSAttributedString(string: stringRank, attributes: titleMajorAttributes))

        let maxRankString = " / " + stringMaxRank + "\n"
        headerAttributedString.append(NSAttributedString(string: maxRankString, attributes: titleAttributes))

        // Add stars
        let rank = challengeDetail.driverStats.rank
        let nbDriverRanked = challengeDetail.nbDriverRanked
        let percentage: Int = Int((Double(100 * rank) / Double(nbDriverRanked)).rounded())
        let goldStarsNbr: Int
        if rank == 0 {
            goldStarsNbr = 0
        } else if rank == 1 || percentage < 25 {
            goldStarsNbr = 4
        } else if percentage < 50 {
            goldStarsNbr = 3
        } else if percentage < 75 {
            goldStarsNbr = 2
        } else {
            goldStarsNbr = 1
        }
        let goldStarsAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 62).with(.traitBold), NSAttributedString.Key.foregroundColor: goldColor]
        let stars = "⭑⭑⭑⭑"
        let goldStarsAttributedString = NSMutableAttributedString(string: String(stars.prefix(goldStarsNbr)), attributes: goldStarsAttributes)
        let lightGoldStarsAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 62).with(.traitBold), NSAttributedString.Key.foregroundColor: lightGoldColor]
        let lightGoldStarsAttributedString = NSMutableAttributedString(string: String(stars.prefix(4 - goldStarsNbr)), attributes: lightGoldStarsAttributes)
        headerAttributedString.append(goldStarsAttributedString)
        headerAttributedString.append(lightGoldStarsAttributedString)

        headerAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: headerAttributedString.length))
        return headerAttributedString
    }

    func getStatAttributedString(challengeStatType: ChallengeStatType) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 15),
            NSAttributedString.Key.foregroundColor: DKUIColors.complementaryFontColor.color
        ]
        let majorAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 22).with(.traitBold),
            NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color
        ]
        switch challengeStatType {
            case .distanceTrips:
                let formattedDistance = challengeDetail.driverStats.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10)
                let trip = challengeDetail.driverStats.numberTrip > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()
                let formattedTrips = String(challengeDetail.driverStats.numberTrip) + " " + trip
                let distanceTripsString = "\(formattedDistance) - \(formattedTrips)"
                return NSAttributedString(string: distanceTripsString, attributes: majorAttributes)
            case .totalDistance:
                let formattedDistance = challengeDetail.challengeStats.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10)
                return NSAttributedString(string: formattedDistance, attributes: majorAttributes)
            case .rankedRegistered:
                let rankedString = challengeDetail.nbDriverRanked > 1 
                ? "dk_challenge_synthesis_ranked_plural".dkChallengeLocalized()
                : "dk_challenge_synthesis_ranked_singular".dkChallengeLocalized()
                let registeredString = challengeDetail.nbDriverRegistered > 1
                ? "dk_challenge_synthesis_registered_plural".dkChallengeLocalized()
                : "dk_challenge_synthesis_registered_singular".dkChallengeLocalized()
                let rankedRegisteredString = "\(challengeDetail.nbDriverRanked) \(rankedString) / \(challengeDetail.nbDriverRegistered) \(registeredString)"
                let attributedResult = NSMutableAttributedString(string: rankedRegisteredString, attributes: majorAttributes)
                let rangeRanked = (rankedRegisteredString as NSString).range(of: rankedString)
                let rangeRegistered = (rankedRegisteredString as NSString).range(of: registeredString)
                attributedResult.setAttributes(titleAttributes, range: rangeRanked)
                attributedResult.setAttributes(titleAttributes, range: rangeRegistered)
                return attributedResult
        }
    }

    func getStatDescriptionAttributedString(challengeStatType: ChallengeStatType) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 12),
            NSAttributedString.Key.foregroundColor: DKUIColors.complementaryFontColor.color
        ]
        let majorAttributes = [
            NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 12).with(.traitBold),
            NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color
        ]
        switch challengeStatType {
            case .distanceTrips:
                return NSAttributedString(string: "dk_challenge_synthesis_my_stats".dkChallengeLocalized(), attributes: titleAttributes)
            case .totalDistance:
                return NSAttributedString(string: "dk_challenge_synthesis_total_distance".dkChallengeLocalized(), attributes: titleAttributes)
            case .rankedRegistered:
                let percentageString = self.nbDriverRankedPercentage
                let rankedPercentageString = String(format: "dk_challenge_synthesis_ranked_percentage".dkChallengeLocalized(), percentageString)
                let attributedResult = NSMutableAttributedString(string: rankedPercentageString, attributes: titleAttributes)

                let rangePercentage = (rankedPercentageString as NSString).range(of: percentageString)
                attributedResult.setAttributes(majorAttributes, range: rangePercentage)
                return attributedResult
        }
    }

    var challengeStats: [ChallengeStatType] {
        return [.distanceTrips, .totalDistance, .rankedRegistered]
    }

    var minScore: Double {
        return challengeDetail.challengeStats.minScore
    }
    var maxScore: Double {
        return challengeDetail.challengeStats.maxScore
    }
    var driverScore: Double {
        return challengeDetail.driverStats.score
    }

    var nbDriverRankedPercentage: String {
        let nbrRanked = challengeDetail.nbDriverRanked
        let nbrRegistered = challengeDetail.nbDriverRegistered
        guard nbrRegistered > 0 else {
            return "-"
        }
        let percent: Double = (Double(nbrRanked) / Double(nbrRegistered)) * 100.0
        return percent.formatPercentage()
    }
}
