// swiftlint:disable no_magic_numbers
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
    func getText() -> NSAttributedString
}

public enum SynthesisCardInfo: DKSynthesisCardInfo {
    case activeDays(trips: [DKTrip])
    case count(trips: [DKTrip])
    case distance(trips: [DKTrip])
    case duration(trips: [DKTrip])

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

    public func getText() -> NSAttributedString {
        let text: NSAttributedString
        switch self {
            case let .activeDays(trips):
                let count = trips.totalActiveDays
                let unitKey: DKCommonLocalizable
                if count > 1 {
                    unitKey = .dayPlural
                } else {
                    unitKey = .daySingular
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
                let unitString = unitKey.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case let .count(trips):
                let count = trips.count
                let unitKey: DKCommonLocalizable
                if count > 1 {
                    unitKey = .tripPlural
                } else {
                    unitKey = .tripSingular
                }
                let valueString = String(count).dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
                let unitString = unitKey.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
                text = "%@ %@".dkAttributedString().buildWithArgs(valueString, unitString)
            case let .distance(trips):
                text = formatTypes(trips.totalDistance.ceilMeterDistance(ifGreaterThan: 10_000).getMeterDistanceFormat())
            case let .duration(trips):
                text = formatTypes(trips.totalDuration.ceilSecondDuration(ifGreaterThan: 600).getSecondDurationFormat(maxUnit: .hour))
        }
        return text
    }

    private func formatTypes(_ formattingTypes: [FormatType]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        for formattingType in formattingTypes {
            switch formattingType {
                case let .separator(value),
                     let .unit(value):
                    attributedString.append(value.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build())
                case let .value(value):
                    attributedString.append(value.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build())
            }
        }
        return attributedString
    }
}
