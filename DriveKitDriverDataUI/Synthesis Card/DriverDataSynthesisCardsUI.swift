//
//  DriverDataSynthesisCardsUI.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 09/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public struct DriverDataSynthesisCardsUI {

    public static func getSynthesisCardView(_ synthesisCard: DKSynthesisCard) -> UIView {
        let synthesisCardView = SynthesisCardView.viewFromNib
        synthesisCardView.synthesisCardViewModel = SynthesisCardViewModel(synthesisCard: synthesisCard)
        return synthesisCardView
    }

    public static func getSynthesisCardViews(_ synthesisCards: [DKSynthesisCard]) -> [UIView] {
        return synthesisCards.map { getSynthesisCardView($0) }
    }

    public static func getLastTripsSynthesisCardsView(_ synthesisCards: [LastTripsSynthesisCard] = [.safety, .ecodriving, .distraction, .speeding]) -> UIView {
        let trips = SynthesisCardUtils.getLastTrips()
        let synthesisCards: [SynthesisCard] = synthesisCards.map {
            switch $0 {
                case .distraction:
                    return SynthesisCard.distraction(trips: trips)
                case .ecodriving:
                    return SynthesisCard.ecodriving(trips: trips)
                case .safety:
                    return SynthesisCard.safety(trips: trips)
                case .speeding:
                    return SynthesisCard.speeding(trips: trips)
            }
        }.filter { $0.hasAccess() }
        return getSynthesisCardsView(synthesisCards)
    }

    public static func getSynthesisCardsView(_ synthesisCards: [DKSynthesisCard]) -> UIView {
        let synthesisCardsView = SynthesisCardsView.viewFromNib
        synthesisCardsView.viewModel = SynthesisCardsViewModel(synthesisCards: synthesisCards)
        return synthesisCardsView
    }

}
