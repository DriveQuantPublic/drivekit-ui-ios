//
//  DKTripCardInfo.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

public protocol DKSynthesisCardInfo {
    func getIcon() -> UIImage?
    func getText(trips: [Trip]) -> NSAttributedString
}

public enum SynthesisCardInfo: DKSynthesisCardInfo {
    case activeDays, count, distance, duration

    public func getIcon() -> UIImage? {
        let image: DKImages
        switch self {
            case .activeDays:
                image = DKImages.calendar
            case .count:
                image = DKImages.trip
            case .distance:
                image = DKImages.road
            case .duration:
                image = DKImages.clock
        }
        return image.image
    }

    public func getText(trips: [Trip]) -> NSAttributedString {
        let valueFontStyle = DKStyle(size: DKStyles.bigtext.style.size, traits: .traitBold)
        let text: NSAttributedString
        switch self {
            case .activeDays:
                let count = trips.totalActiveDays
                let unitKey: DKCommonLocalizable
                if count > 1 {
                    unitKey = .dayPlural
                } else {
                    unitKey = .daySingular
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: valueFontStyle).color(.primaryColor).build()
                let unitString = unitKey.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case .count:
                let count = trips.count
                let unitKey: DKCommonLocalizable
                if count > 1 {
                    unitKey = .tripPlural
                } else {
                    unitKey = .tripSingular
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: valueFontStyle).color(.primaryColor).build()
                let unitString = unitKey.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case .distance:
                text = trips.totalDistance.formatMeterDistance().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            case .duration:
                text = trips.totalDuration.formatSecondDuration().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        }
        return text
    }
}
