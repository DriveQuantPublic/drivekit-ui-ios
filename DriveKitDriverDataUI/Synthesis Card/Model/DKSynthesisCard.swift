//
//  DKSynthesisCard.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

public protocol DKSynthesisCard {
    func getTitle() -> String
    func getExplanationContent() -> String?
    func getGaugeConfiguration() -> DKGaugeConfiguration
    func getTopSynthesisCardInfo() -> DKSynthesisCardInfo
    func getMiddleSynthesisCardInfo() -> DKSynthesisCardInfo
    func getBottomSynthesisCardInfo() -> DKSynthesisCardInfo
    func getBottomText() -> NSAttributedString?
}

public struct SynthesisCard: DKSynthesisCard {
    public static let distraction = SynthesisCard(type: .distraction)
    public static let ecodriving = SynthesisCard(type: .ecodriving)
    public static let safety = SynthesisCard(type: .safety)
    public static let speeding = SynthesisCard(type: .speeding)

    private let type: SynthesisCardType
    private let trips: [Trip] = SynthesisCardUtils.getLastTrips()

    private init(type: SynthesisCardType) {
        self.type = type
    }

    public func getTitle() -> String {
        let titleKey: String
        switch self.type {
            case .distraction:
                titleKey = "dk_driverdata_my_weekly_score_distraction"
            case .ecodriving:
                titleKey = "dk_driverdata_my_weekly_score_ecodriving"
            case .safety:
                titleKey = "dk_driverdata_my_weekly_score_safety"
            case .speeding:
                titleKey = "dk_driverdata_my_weekly_score_speeding"
        }
        return titleKey.dkDriverDataLocalized()
    }

    public func getExplanationContent() -> String? {
        "dk_driverdata_synthesis_card_explanation".dkDriverDataLocalized()
    }

    public func getGaugeConfiguration() -> DKGaugeConfiguration {
        let scoreType: ScoreType
        switch self.type {
            case .distraction:
                scoreType = .distraction
            case .ecodriving:
                scoreType = .ecoDriving
            case .safety:
                scoreType = .safety
            case .speeding:
                scoreType = .speeding
        }
        let validTrips = self.trips.filter { scoreType.rawValue(trip: $0) <= 10 }
        let totalScore = validTrips.map { scoreType.rawValue(trip: $0) }.reduce(0.0, +)
        let value = totalScore / Double(validTrips.count)
        return ConfigurationCircularProgressView(scoreType: scoreType, value: value, size: .large)
    }

    public func getTopSynthesisCardInfo() -> DKSynthesisCardInfo {
        return SynthesisCardInfo.count
    }

    public func getMiddleSynthesisCardInfo() -> DKSynthesisCardInfo {
        return SynthesisCardInfo.distance
    }

    public func getBottomSynthesisCardInfo() -> DKSynthesisCardInfo {
        return SynthesisCardInfo.duration
    }

    public func getBottomText() -> NSAttributedString? {
        #warning("TODO")
        return nil
    }

}

private enum SynthesisCardType {
    case distraction, ecodriving, safety, speeding
}
