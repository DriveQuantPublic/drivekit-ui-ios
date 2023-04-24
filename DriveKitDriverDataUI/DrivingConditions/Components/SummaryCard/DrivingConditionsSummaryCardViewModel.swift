//
//  DrivingConditionsSummaryCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 07/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI

class DrivingConditionsSummaryCardViewModel {
    public var hasNoData: Bool = true
    private var tripCount: Int = 0
    private var totalDistance: Double = 0.0
    var summaryCardViewModelDidUpdate: (() -> Void)?
    
    init() {}
    
    func configureWithNoData() {
        self.configure()
    }
    
    func configure(
        tripCount: Int = 0,
        totalDistance: Double = 0
    ) {
        self.hasNoData = tripCount <= 0 && totalDistance <= 0
        self.tripCount = tripCount
        self.totalDistance = totalDistance
        summaryCardViewModelDidUpdate?()
    }
    
    var noDataTitleText: String? {
        guard hasNoData else { return nil }
        
        return DKCommonLocalizable.noDataYet.text()
    }
    
    var noDataDescriptionText: String? {
        guard hasNoData else { return nil }
        
        return "dk_driverdata_drivingconditions_empty_data".dkDriverDataLocalized()
    }
    
    var tripCountText: NSAttributedString? {
        if hasNoData { return nil }
        return tripCount.formatWithThousandSeparator()
            .dkAttributedString()
            .color(.primaryColor)
            .font(dkFont: .secondary, style: .highlightNormal)
            .build()
    }
    
    var tripCountUnitText: NSAttributedString? {
        if hasNoData { return nil }
        
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
    
    var totalDistanceText: NSAttributedString? {
        if hasNoData { return nil }
        return totalDistance.formatKilometerDistance(
            appendingUnit: false,
            minDistanceToRemoveFractions: DrivingConditionsConstants.minDistanceToRemoveFractions(forTotalDistance: totalDistance)
        )
            .dkAttributedString()
            .color(.primaryColor)
            .font(dkFont: .secondary, style: .highlightNormal)
            .build()
    }
    
    var totalDistanceUnitText: NSAttributedString? {
        if hasNoData { return nil }
        return (
            totalDistance <= 1
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
