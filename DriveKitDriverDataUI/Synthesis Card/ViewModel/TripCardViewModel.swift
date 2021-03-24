//
//  TripCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class TripCardViewModel {
    private let tripCard: DKSynthesisCard
    private let trips: [Trip]

    init(tripCard: DKSynthesisCard, trips: [Trip]) {
        self.tripCard = tripCard
        self.trips = trips
    }

    func getTitle() -> String {
        self.tripCard.getTitle()
    }

    func getExplanationContent() -> String? {
        self.tripCard.getExplanationContent()
    }

    func getGaugeConfiguration() -> ConfigurationCircularProgressView {
        #warning("TODO")
        let gaugeConfig = self.tripCard.getGaugeConfiguration()
        return ConfigurationCircularProgressView(scoreType: .distraction, value: gaugeConfig.getProgress(), size: .large)
    }

    func getTripCardInfoList() -> [TripCardInfoViewModel] {
//        let tripCardInfoList = self.tripCard.getTripCardInfo(trips: self.trips)
//        return tripCardInfoList.map { tripCardInfo in
//            TripCardInfoViewModel(tripCardInfo: tripCardInfo, trips: self.trips)
//        }
        return []
    }

    func getBottomText() -> NSAttributedString? {
        self.tripCard.getBottomText()
    }
}
