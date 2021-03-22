//
//  DKTripCard.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

public protocol DKTripCard {
    func getTitle(trips: [Trip]) -> String
    func getExplanationContent(trips: [Trip]) -> String?
    func getGaugeConfiguration(value: Double) -> ConfigurationCircularProgressView
    func getTripCardInfo(trips: [Trip]) -> [DKTripCardInfo]
    func getBottomText(trips: [Trip]) -> NSAttributedString?
}

public enum ScoreTripCard: DKTripCard {
    case distraction, ecodriving, safety, speeding

    public func getTitle(trips: [Trip]) -> String {
        let titleKey: String
        switch self {
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

    public func getExplanationContent(trips: [Trip]) -> String? {
        "dk_driverdata_synthesis_card_explanation".dkDriverDataLocalized()
    }

    public func getGaugeConfiguration(value: Double) -> ConfigurationCircularProgressView {
        let scoreType: ScoreType
        switch self {
            case .distraction:
                scoreType = .distraction
            case .ecodriving:
                scoreType = .ecoDriving
            case .safety:
                scoreType = .safety
            case .speeding:
                scoreType = .speeding
        }
        return ConfigurationCircularProgressView(scoreType: scoreType, value: value, size: .large)
    }

    public func getTripCardInfo(trips: [Trip]) -> [DKTripCardInfo] {
        #warning("TODO")
        return [DKTripCardInfo]()
    }

    public func getBottomText(trips: [Trip]) -> NSAttributedString? {
        #warning("TODO")
        return nil
    }

}
