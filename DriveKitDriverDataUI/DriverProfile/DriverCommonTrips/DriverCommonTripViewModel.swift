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
            of: Double(self.commonTrip?.distanceMean ?? defaultDistanceMeanForNoDataState)
                .getKilometerDistanceFormat(
                    appendingUnit: true,
                    minDistanceToRemoveFractions: 0
                )
        )
    }
    
    var durationText: NSAttributedString {
        let secondsInMinute = 60
        return formattedText(
            of: Double(
                (self.commonTrip?.durationMean ?? defaultDurationMeanForNoDataState) * secondsInMinute
            )
                .getSecondDurationFormat(maxUnit: .hour)
        )
    }
    
    private func formattedText(of format: [FormatType]) -> NSMutableAttributedString {
        let valueColor = self.hasData ? DKUIColors.primaryColor : .complementaryFontColor
        let unitColor = self.hasData ? DKUIColors.mainFontColor : .complementaryFontColor
        
        let formatString = format.reduce(into: "") { acc, _ in
            acc += "%@"
        }
        let attributedStrings = format.map {
            switch $0 {
            case let .value(text):
                return text.dkAttributedString()
                    .font(dkFont: .primary, style: .highlightNormal)
                    .color(valueColor)
                    .build()
            case let .unit(text),
                 let .separator(text):
                return text.dkAttributedString()
                    .font(dkFont: .primary, style: .normalText)
                    .color(unitColor)
                    .build()
            }
        }
        
        return formatString.dkAttributedString()
            .buildWithArgs(attributedStrings)
    }
    
    var conditionsText: String {
        (self.commonTrip?.roadContext ?? defaultContextForNoDataState).mostFrequentTripContext
    }
    
    var conditionsTextColor: DKUIColors {
        self.hasData ? DKUIColors.mainFontColor : .complementaryFontColor
    }
}
