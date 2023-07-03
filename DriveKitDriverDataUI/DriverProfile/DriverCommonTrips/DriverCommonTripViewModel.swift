//
//  DriverCommonTripViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitDBTripAccessModule
import Foundation

class DriverCommonTripViewModel {
    var commonTripType: DKCommonTripType
    var commonTrip: DKCommonTrip?
    var viewModelDidUpdate: (() -> Void)?

    init(commonTripType: DKCommonTripType) {
        self.commonTripType = commonTripType
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
        "42 km".dkAttributedString()
            .build()
    }
    
    var durationText: NSAttributedString {
        "42 min".dkAttributedString()
            .build()
    }
    
    var conditionsText: String {
        "dans les chemins de traverse"
    }
}
