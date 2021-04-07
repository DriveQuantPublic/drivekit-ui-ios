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
                titleKey = "dk_driverdata_weekly_score_distraction"
            case .ecodriving:
                titleKey = "dk_driverdata_weekly_score_ecodriving"
            case .safety:
                titleKey = "dk_driverdata_weekly_score_safety"
            case .speeding:
                titleKey = "dk_driverdata_weekly_score_speeding"
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
        return GaugeConfiguration(trips: self.trips, scoreType: scoreType)
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
        let (roadCondition, percentage) = SynthesisCardUtils.getMainRoadCondition(ofTrips: self.trips)
        let textKey: String?
        switch roadCondition {
            case .city:
                textKey = "dk_driverdata_urban"
            case .expressways:
                textKey = "dk_driverdata_expressway"
            case .heavyUrbanTraffic:
                textKey = "dk_driverdata_dense_urban"
            case .suburban:
                textKey = "dk_driverdata_extra_urban"
            case .trafficJam:
                textKey = nil
        }
        if let textKey = textKey {
            let value = String(format: "%.0f%%", percentage).dkAttributedString().color(.primaryColor).font(dkFont: .primary, style: .normalText).build()
            return textKey.dkDriverDataLocalized().dkAttributedString().color(.mainFontColor).font(dkFont: .primary, style: .normalText).buildWithArgs(value)
        }
        return nil
    }

}

private struct GaugeConfiguration : DKGaugeConfiguration {
    let trips: [Trip]
    let scoreType: ScoreType
    let value: Double
    private let progress: Double
    private let gaugeType: DKGaugeType

    init(trips: [Trip], scoreType: ScoreType) {
        self.trips = trips.filter { scoreType.rawValue(trip: $0) <= 10 }
        self.scoreType = scoreType
        if self.trips.isEmpty {
            self.value = Double(0)
        } else {
            let totalScore = self.trips.map { scoreType.rawValue(trip: $0) }.reduce(0.0, +)
            self.value = totalScore / Double(self.trips.count)
        }
        self.progress = self.value / 10.0
        if let icon = scoreType.image() {
            self.gaugeType = .openWithIcon(icon)
        } else {
            self.gaugeType = .open
        }
    }

    func getColor() -> UIColor {
        ConfigurationCircularProgressView.getScoreColor(value: self.value, steps: self.scoreType.getSteps())
    }

    func getGaugeType() -> DKGaugeType {
        self.gaugeType
    }

    func getProgress() -> Double {
        self.progress
    }

    func getTitle() -> String {
        self.value.formatDouble(places: 1)
    }
}

private enum SynthesisCardType {
    case distraction, ecodriving, safety, speeding
}
