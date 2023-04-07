//
//  TripDistanceCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 07/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI

class TripDistanceCardViewModel {
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
            .font(dkFont: .primary, style: .highlightSmall)
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
            .color(.secondaryColor)
            .font(dkFont: .primary, style: .normalText)
            .build()
    }
    
    var totalDistanceText: NSAttributedString {
        totalDistance.formatMeterDistanceInKm(appendingUnit: false)
            .dkAttributedString()
            .color(.primaryColor)
            .font(dkFont: .primary, style: .highlightSmall)
            .build()
    }
    
    var totalDistanceUnitText: NSAttributedString {
        #warning("Fix localisation with the correct key ")
        return DKCommonLocalizable.unitKilometer.text()
            .dkAttributedString()
            .color(.secondaryColor)
            .font(dkFont: .primary, style: .normalText)
            .build()
    }
}
