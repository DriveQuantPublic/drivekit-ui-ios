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

    func getTripCardInfoList() -> [SynthesisCardInfoViewModel] {
//        let tripCardInfoList = self.synthesisCard.getTripCardInfo(trips: self.trips)
//        return tripCardInfoList.map { tripCardInfo in
//            TripCardInfoViewModel(tripCardInfo: tripCardInfo, trips: self.trips)
//        }
        return []
    }

    func getBottomText() -> NSAttributedString? {
        self.synthesisCard.getBottomText()
    }
}
