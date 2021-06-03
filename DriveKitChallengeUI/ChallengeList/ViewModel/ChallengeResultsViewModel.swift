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

struct ChallengeResultsViewModel {
    private let challengeDetail: DKChallengeDetail
    let challengeType: ChallengeType
    let challengeTheme: ChallengeTheme
    private let goldColor = UIColor(red: 255, green: 215, blue: 0)
    private let lightGoldColor = UIColor(red: 1, green: 215.0/255, blue: 0, alpha: 0.2)

    init(challengeDetail: DKChallengeDetail,
         challengeType: ChallengeType = .score,
         challengeTheme: ChallengeTheme = .safety) {
        self.challengeDetail = challengeDetail
        self.challengeTheme = challengeTheme
        self.challengeType = challengeType
    }

    func getDriverNickname() -> String {
        let currentDriver = challengeDetail.driverRanked.filter({ driverRanked in
            return driverRanked.rank == challengeDetail.userIndex
        }).first
        return currentDriver?.nickname ?? ""
    }

    func getHeaderCellAttributedString() -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleMajorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 44).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let name = getDriverNickname()
        let stringRank = String(challengeDetail.userIndex)
        let stringMaxRank = String(challengeDetail.challengeStats.numberDriver)
        
        let scoreHeaderString = name + " " + stringRank + "/" + stringMaxRank + "\n"
        let headerAttributedString = NSMutableAttributedString(string: scoreHeaderString, attributes: titleAttributes)
        let rankRange = (scoreHeaderString as NSString).range(of: stringRank)
        headerAttributedString.setAttributes(titleMajorAttributes, range: rankRange)

        // Add stars
        let score = challengeDetail.driverStats.score
        let maxScore = challengeDetail.challengeStats.maxScore
        let goldStarsNbr: Int = Int(((4 * score) / maxScore).rounded(.down))
        let goldStarsAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 66).with(.traitBold), NSAttributedString.Key.foregroundColor: goldColor]
        let stars = "⭑⭑⭑⭑"
        let goldStarsAttributedString = NSMutableAttributedString(string: String(stars.prefix(goldStarsNbr)), attributes: goldStarsAttributes)
        let lightGoldStarsAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 60).with(.traitBold), NSAttributedString.Key.foregroundColor: lightGoldColor]
        let lightGoldStarsAttributedString = NSMutableAttributedString(string: String(stars.prefix(4 - goldStarsNbr)), attributes: lightGoldStarsAttributes)
        headerAttributedString.append(goldStarsAttributedString)
        headerAttributedString.append(lightGoldStarsAttributedString)

        headerAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: headerAttributedString.length))
        return headerAttributedString
    }

    func getStatAttributedString(challengeStatType: ChallengeStatType) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
        let majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 18).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
        switch challengeStatType {
        case .duration:
            let duration = challengeDetail.driverStats.duration * 3600
            let formattedDuration = duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour)
            let durationString = String(format: "dk_challenge_driver_duration".dkChallengeLocalized(), formattedDuration)
            let rangeDuration = (durationString as NSString).range(of: formattedDuration)
            let attributedDuration = NSMutableAttributedString(string: durationString, attributes: titleAttributes)
            attributedDuration.setAttributes(majorAttributes, range: rangeDuration)
            return attributedDuration
        case .distance:
            let formattedDistance = challengeDetail.driverStats.distance.formatKilometerDistance()
            let distanceString = String(format: "dk_challenge_driver_distance".dkChallengeLocalized(), formattedDistance)
            let rangeDistance = (distanceString as NSString).range(of: formattedDistance)
            let attributedDistance = NSMutableAttributedString(string: distanceString, attributes: titleAttributes)
            attributedDistance.setAttributes(majorAttributes, range: rangeDistance)
            return attributedDistance
        case .nbTrips:
            let trip = challengeDetail.driverStats.numberTrip > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()
            let tripsFormatted = String(challengeDetail.driverStats.numberTrip) + " " + trip
            let tripsString = String(format: "dk_challenge_driver_trips".dkChallengeLocalized(), tripsFormatted)
            let rangeTrips = (tripsString as NSString).range(of:  tripsFormatted)
            let attributedTrips = NSMutableAttributedString(string: tripsString, attributes: titleAttributes)
            attributedTrips.setAttributes(majorAttributes, range: rangeTrips)
            return attributedTrips
        }
    }

    func getGlobalStatAttributedString(challengeStatType: ChallengeStatType) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 12), NSAttributedString.Key.foregroundColor: UIColor.black]
        let majorAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color]
        switch challengeStatType {
        case .duration:
            let duration = challengeDetail.challengeStats.duration * 3600
            let formattedDuration = duration.ceilSecondDuration(ifGreaterThan: 600).formatSecondDuration(maxUnit: .hour)
            let durationString = String(format: "dk_challenge_competitors_duration".dkChallengeLocalized(), formattedDuration)
            let rangeDuration = (durationString as NSString).range(of: formattedDuration)
            let attributedDuration = NSMutableAttributedString(string: durationString, attributes: titleAttributes)
            attributedDuration.setAttributes(majorAttributes, range: rangeDuration)
            return attributedDuration
        case .distance:
            let formattedDistance = challengeDetail.challengeStats.distance.formatKilometerDistance()
            let distanceString = String(format: "dk_challenge_competitors_distance".dkChallengeLocalized(), formattedDistance)
            let rangeDistance = (distanceString as NSString).range(of: formattedDistance)
            let attributedDistance = NSMutableAttributedString(string: distanceString, attributes: titleAttributes)
            attributedDistance.setAttributes(majorAttributes, range: rangeDistance)
            return attributedDistance
        case .nbTrips:
            let trip = challengeDetail.challengeStats.numberTrip > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()
            let tripsFormatted = String(challengeDetail.challengeStats.numberTrip) + " " + trip
            let tripsString = String(format: "dk_challenge_driver_trips".dkChallengeLocalized(), tripsFormatted)
            let rangeTrips = (tripsString as NSString).range(of:  tripsFormatted)
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
