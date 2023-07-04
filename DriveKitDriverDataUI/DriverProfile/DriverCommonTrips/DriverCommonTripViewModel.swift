//
//  DriverCommonTripViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation

class DriverCommonTripViewModel {
    let defaultDistanceMeanForNoDataState = 36
    let defaultDurationMeanForNoDataState = 34
    let defaultContextForNoDataState = DKRoadContext.suburban
    var commonTripType: DKCommonTripType
    var commonTrip: DKCommonTrip?
    var viewModelDidUpdate: (() -> Void)?

    init(commonTripType: DKCommonTripType) {
        self.commonTripType = commonTripType
    }
    
    var hasData: Bool {
        commonTrip != nil
    }
    
    func configure(with commonTrip: DKCommonTrip) {
        guard commonTrip.type == self.commonTripType else {
            assertionFailure("We should receive a common trip of the same type as the card (\(commonTrip.type) ≠ \(self.commonTripType)")
            return
        }
        self.commonTrip = commonTrip
        self.viewModelDidUpdate?()
    }
    
    func configureWithNoData() {
        self.commonTrip = nil
        self.viewModelDidUpdate?()
    }
    
    var distanceText: NSAttributedString {
        formattedText(
            for: Double(self.commonTrip?.distanceMean ?? defaultDistanceMeanForNoDataState)
                .formatKilometerDistance(
                    appendingUnit: false,
                    minDistanceToRemoveFractions: 0
                ),
            unit: DKCommonLocalizable.unitKilometer.text()
        )
    }
    
    var durationText: NSAttributedString {
        formattedText(
            for: Double(self.commonTrip?.durationMean ?? defaultDurationMeanForNoDataState)
                .formatDouble(fractionDigits: 0),
            unit: DKCommonLocalizable.unitMinute.text()
        )
    }
    
    private func formattedText(for valueText: String, unit unitText: String) -> NSAttributedString {
        let valueColor = self.hasData ? DKUIColors.primaryColor : .complementaryFontColor
        let unitColor = self.hasData ? DKUIColors.mainFontColor : .complementaryFontColor
        return valueText.dkAttributedString()
            .font(dkFont: .primary, style: .highlightNormal)
            .color(valueColor)
            .buildWithArgs(
                (String.nonBreakableSpace + unitText).dkAttributedString()
                    .font(dkFont: .primary, style: .normalText)
                    .color(unitColor)
                    .build()
            )
    }
    
    var conditionsText: String {
        (self.commonTrip?.roadContext ?? defaultContextForNoDataState).mostFrequentTripContext
    }
    
    var conditionsTextColor: DKUIColors {
        self.hasData ? DKUIColors.mainFontColor : .complementaryFontColor
    }
}
