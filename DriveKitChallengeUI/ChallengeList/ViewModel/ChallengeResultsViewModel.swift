// swiftlint:disable all
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
    let challengeType: ChallengeType
    let challengeTheme: ChallengeTheme
    private let goldColor = UIColor(red: 255, green: 215, blue: 0)
    private let lightGoldColor = UIColor(red: 1, green: 215.0 / 255, blue: 0, alpha: 0.2)

    init(challengeDetail: DKChallengeDetail,
         challengeType: ChallengeType = .score,
         challengeTheme: ChallengeTheme = .safety) {
        self.challengeDetail = challengeDetail
        self.challengeTheme = challengeTheme
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
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleMajorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 44).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.secondaryColor.color]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 0.85

        let name = getDriverPseudo()
        let stringRank = String(challengeDetail.userIndex)
        let stringMaxRank = String(challengeDetail.challengeStats.numberDriver)
        
        let scoreHeaderString = "\n" + name + " "
        let headerAttributedString = NSMutableAttributedString(string: scoreHeaderString, attributes: titleAttributes)
        
        headerAttributedString.append(NSAttributedString(string: stringRank, attributes: titleMajorAttributes))

        let maxRankString = " / " + stringMaxRank + "\n"
        headerAttributedString.append(NSAttributedString(string: maxRankString, attributes: titleAttributes))

        // Add stars
        let rank = challengeDetail.driverStats.rank
        let nbrDrivers = challengeDetail.challengeStats.numberDriver
        let percentage: Double = Double(100 * rank) / Double(nbrDrivers)
        let goldStarsNbr: Int
        if rank == 0 {
            goldStarsNbr = 0
        } else if rank == 1 || percentage <= 25 {
            goldStarsNbr = 4
        } else if percentage <= 50 {
            goldStarsNbr = 3
        } else if percentage <= 75 {
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
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
        let majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 18).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color]
        switch challengeStatType {
        case .duration:
            let duration = challengeDetail.driverStats.duration * 3_600
            let formattedDuration = duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour)
            let durationString = String(format: "dk_challenge_driver_duration".dkChallengeLocalized(), formattedDuration)
            let rangeDuration = (durationString as NSString).range(of: formattedDuration)
            let attributedDuration = NSMutableAttributedString(string: durationString, attributes: titleAttributes)
            attributedDuration.setAttributes(majorAttributes, range: rangeDuration)
            return attributedDuration
        case .distance:
            let formattedDistance = challengeDetail.driverStats.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10)
            let distanceString = String(format: "dk_challenge_driver_distance".dkChallengeLocalized(), formattedDistance)
            let rangeDistance = (distanceString as NSString).range(of: formattedDistance)
            let attributedDistance = NSMutableAttributedString(string: distanceString, attributes: titleAttributes)
            attributedDistance.setAttributes(majorAttributes, range: rangeDistance)
            return attributedDistance
        case .nbTrips:
            let trip = challengeDetail.driverStats.numberTrip > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()
            let tripsFormatted = String(challengeDetail.driverStats.numberTrip) + " " + trip
            let tripsString = String(format: "dk_challenge_driver_trips".dkChallengeLocalized(), tripsFormatted)
            let rangeTrips = (tripsString as NSString).range(of: tripsFormatted)
            let attributedTrips = NSMutableAttributedString(string: tripsString, attributes: titleAttributes)
            attributedTrips.setAttributes(majorAttributes, range: rangeTrips)
            return attributedTrips
        }
    }

    func getGlobalStatAttributedString(challengeStatType: ChallengeStatType) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 12), NSAttributedString.Key.foregroundColor: DKUIColors.complementaryFontColor.color]
        let majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.primaryColor.color]
        switch challengeStatType {
        case .duration:
            let duration = challengeDetail.challengeStats.duration * 3_600
            let formattedDuration = duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour)
            let durationString = String(format: "dk_challenge_competitors_duration".dkChallengeLocalized(), formattedDuration)
            let rangeDuration = (durationString as NSString).range(of: formattedDuration)
            let attributedDuration = NSMutableAttributedString(string: durationString, attributes: titleAttributes)
            attributedDuration.setAttributes(majorAttributes, range: rangeDuration)
            return attributedDuration
        case .distance:
            let formattedDistance = challengeDetail.challengeStats.distance.formatKilometerDistance(appendingUnit: true, minDistanceToRemoveFractions: 10)
            let distanceString = String(format: "dk_challenge_competitors_distance".dkChallengeLocalized(), formattedDistance)
            let rangeDistance = (distanceString as NSString).range(of: formattedDistance)
            let attributedDistance = NSMutableAttributedString(string: distanceString, attributes: titleAttributes)
            attributedDistance.setAttributes(majorAttributes, range: rangeDistance)
            return attributedDistance
        case .nbTrips:
            let trip = challengeDetail.challengeStats.numberTrip > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()
            let tripsFormatted = String(challengeDetail.challengeStats.numberTrip) + " " + trip
            let tripsString = String(format: "dk_challenge_competitors_trips".dkChallengeLocalized(), tripsFormatted)
            let rangeTrips = (tripsString as NSString).range(of: tripsFormatted)
            let attributedTrips = NSMutableAttributedString(string: tripsString, attributes: titleAttributes)
            attributedTrips.setAttributes(majorAttributes, range: rangeTrips)
            return attributedTrips
        }
    }

    var challengeStats: [ChallengeStatType] {
        switch challengeType {
        case .distance:
            return [.duration, .nbTrips]
        case .duration:
            return [.distance, .nbTrips]
        case .score:
            return [.distance, .duration, .nbTrips]
        case .nbTrips:
            return [.distance, .duration]
        }
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
    var numberTrip: Int {
        return challengeDetail.driverStats.numberTrip
    }
}
