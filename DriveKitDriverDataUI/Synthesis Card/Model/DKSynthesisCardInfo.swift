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
        let imageName: String
        switch self {
            case .activeDays:
                imageName = "dk_common_calendar"
            case .count:
                imageName = "dk_common_trip"
            case .distance:
                imageName = "dk_common_road"
            case .duration:
                imageName = "dk_common_clock"
        }
        return UIImage(named: imageName)
    }

    public func getText(trips: [Trip]) -> NSAttributedString {
        let valueFontStyle = DKStyle(size: DKStyles.bigtext.style.size, traits: .traitBold)
        let text: NSAttributedString
        switch self {
            case .activeDays:
                let count = trips.totalActiveDays
                let unitKey: String
                if count > 1 {
                    unitKey = "dk_common_trip_plural"
                } else {
                    unitKey = "dk_common_trip_singular"
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: valueFontStyle).color(.primaryColor).build()
                let unitString = unitKey.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case .count:
                let count = trips.count
                let unitKey: String
                if count > 1 {
                    unitKey = "dk_common_day_plural"
                } else {
                    unitKey = "dk_common_day_singular"
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: valueFontStyle).color(.primaryColor).build()
                let unitString = unitKey.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case .distance:
                text = trips.totalDistance.formatMeterDistance().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            case .duration:
                text = trips.totalDuration.formatSecondDuration().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        }
        return text
    }
}
