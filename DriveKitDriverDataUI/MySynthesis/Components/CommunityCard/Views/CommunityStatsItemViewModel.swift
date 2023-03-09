//
//  CommunityStatsItemViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import Foundation

public struct CommunityStatsItemViewModel {
    public var legendColor: DKUIColors
    public var legendTitle: String
    public var tripCount: Int?
    public var distanceCount: Double?
    public var driverCount: Int?
    
    public var tripCountText: NSAttributedString? {
        guard let tripCount else { return nil }
        let text = (tripCount.formatWithThousandSeparator() + String.nonBreakableSpace)
            .dkAttributedString()
            .color(.complementaryFontColor)
            .font(dkFont: .primary, style: .normalText)
            .build()
        let unitText: String
        if tripCount > 1 {
            unitText = DKCommonLocalizable.tripPlural.text()
        } else {
            unitText = DKCommonLocalizable.tripSingular.text()
        }
        
        return "%@%@".dkAttributedString()
            .buildWithArgs(
                text,
                unitText.dkAttributedString()
                    .color(.complementaryFontColor)
                    .font(dkFont: .primary, style: .smallText)
                    .build()
            )
    }
    
    public var distanceCountText: NSAttributedString? {
        let format = distanceCount?.getKilometerDistanceFormat()
        let other = format?.filter({
            guard case .unit = $0 else { return true }
            return false
        })
        let unit = format?.filter({
            guard case .unit = $0 else { return false }
            return true
        })
        
        guard
            let text = other?.toString()
                .dkAttributedString()
                .color(.complementaryFontColor)
                .font(dkFont: .primary, style: .normalText)
                .build(),
            let unitText = unit?.toString()
                .dkAttributedString()
                .color(.complementaryFontColor)
                .font(dkFont: .primary, style: .smallText)
                .build()
        else {
            assertionFailure("Can't convert \(String(describing: distanceCount)) into an attributed string formatted in km")
            return nil
        }
        
        return "%@%@".dkAttributedString()
            .buildWithArgs(text, unitText)
    }
    
    public var driverCountText: NSAttributedString? {
        guard let driverCount else { return nil }
        let text = (driverCount.formatWithThousandSeparator() + String.nonBreakableSpace)
            .dkAttributedString()
            .color(.complementaryFontColor)
            .font(dkFont: .primary, style: .normalText)
            .build()
        let unitText = "dk_driverdata_mysynthesis_drivers".dkDriverDataLocalized()
            .dkAttributedString()
            .color(.complementaryFontColor)
            .font(dkFont: .primary, style: .smallText)
            .build()
        
        return "%@%@".dkAttributedString()
            .buildWithArgs(text, unitText)
    }
}
