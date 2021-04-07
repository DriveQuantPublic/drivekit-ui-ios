//
//  SynthesisCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

struct SynthesisCardViewModel {
    private let synthesisCard: DKSynthesisCard
    private let trips: [Trip]

    init(synthesisCard: DKSynthesisCard, trips: [Trip]) {
        self.synthesisCard = synthesisCard
        self.trips = trips
    }

    func getTitle() -> String {
        self.synthesisCard.getTitle()
    }

    func getExplanationContent() -> String? {
        self.synthesisCard.getExplanationContent()
    }

    func getGaugeConfiguration() -> ConfigurationCircularProgressView {
        return ConfigurationCircularProgressView(gaugeConfiguration: self.synthesisCard.getGaugeConfiguration(), size: .large)
    }

    func getTopSynthesisCardInfoViewModel() -> SynthesisCardInfoViewModel {
        return getSynthesisCardInfoViewModel(from: self.synthesisCard.getTopSynthesisCardInfo())
    }

    func getMiddleSynthesisCardInfoViewModel() -> SynthesisCardInfoViewModel {
        return getSynthesisCardInfoViewModel(from: self.synthesisCard.getMiddleSynthesisCardInfo())
    }

    func getBottomSynthesisCardInfoViewModel() -> SynthesisCardInfoViewModel {
        return getSynthesisCardInfoViewModel(from: self.synthesisCard.getBottomSynthesisCardInfo())
    }

    func getBottomText() -> NSAttributedString? {
        self.synthesisCard.getBottomText()
    }

    private func getSynthesisCardInfoViewModel(from synthesisCardInfo: DKSynthesisCardInfo) -> SynthesisCardInfoViewModel {
        return SynthesisCardInfoViewModel(synthesisCardInfo: synthesisCardInfo, trips: self.trips)
    }
}
