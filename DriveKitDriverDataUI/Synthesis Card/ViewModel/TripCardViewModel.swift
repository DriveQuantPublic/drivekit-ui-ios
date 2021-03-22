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
    private let tripCard: DKTripCard
    private let trips: [Trip]

    init(tripCard: DKTripCard, trips: [Trip]) {
        self.tripCard = tripCard
        self.trips = trips
    }

    func getTitle() -> String {
        self.tripCard.getTitle(trips: self.trips)
    }

    func getExplanationContent() -> String? {
        self.tripCard.getExplanationContent(trips: self.trips)
    }

    func getGaugeConfiguration() -> ConfigurationCircularProgressView {
        #warning("TODO")
        return self.tripCard.getGaugeConfiguration(value: 0)
    }

    func getTripCardInfoList() -> [TripCardInfoViewModel] {
        let tripCardInfoList = self.tripCard.getTripCardInfo(trips: self.trips)
        return tripCardInfoList.map { tripCardInfo in
            TripCardInfoViewModel(tripCardInfo: tripCardInfo, trips: self.trips)
        }
    }

    func getBottomText() -> NSAttributedString? {
        self.tripCard.getBottomText(trips: self.trips)
    }
}
