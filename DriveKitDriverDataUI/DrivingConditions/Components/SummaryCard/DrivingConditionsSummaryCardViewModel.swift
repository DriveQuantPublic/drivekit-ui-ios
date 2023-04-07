//
//  DrivingConditionsSummaryCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 07/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI

class DrivingConditionsSummaryCardViewModel {
    private var tripCount: Int = 0
    private var totalDistance: Double = 0.0
    var tripDistanceCardViewModelDidUpdate: (() -> Void)?
    
    init() {}
    
    func configure(
        tripCount: Int,
        totalDistance: Double
    ) {
        self.tripCount = tripCount
        self.totalDistance = totalDistance
        tripDistanceCardViewModelDidUpdate?()
    }
    
    var tripCountText: NSAttributedString {
        tripCount.formatWithThousandSeparator()
            .dkAttributedString()
            .color(.primaryColor)
            .font(dkFont: .primary, style: .highlightNormal)
            .build()
    }
    
    var tripCountUnitText: NSAttributedString {
        let unitText: String
        if tripCount > 1 {
            unitText = DKCommonLocalizable.tripPlural.text()
        } else {
            unitText = DKCommonLocalizable.tripSingular.text()
        }
        
        return unitText
            .dkAttributedString()
            .color(.complementaryFontColor)
            .font(dkFont: .primary, style: .smallText)
            .build()
    }
    
    var totalDistanceText: NSAttributedString {
        totalDistance.formatKilometerDistance(appendingUnit: false)
            .dkAttributedString()
            .color(.primaryColor)
            .font(dkFont: .secondary, style: .highlightNormal)
            .build()
    }
    
    var totalDistanceUnitText: NSAttributedString {
        return (
            totalDistance == 1
            ? "dk_driverdata_drivingconditions_distance_singular"
            : "dk_driverdata_drivingconditions_distance_plural"
        )
            .dkDriverDataLocalized()
            .dkAttributedString()
            .color(.complementaryFontColor)
            .font(dkFont: .primary, style: .smallText)
            .build()
    }
}
