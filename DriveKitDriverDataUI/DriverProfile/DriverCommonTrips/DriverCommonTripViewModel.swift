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
    var viewModelDidUpdate: (() -> Void)?

    init(commonTripType: DKCommonTripType) {
        self.commonTripType = commonTripType
    }
    
    func configure() {
        #warning("TODO: implement view model update")
        self.viewModelDidUpdate?()
    }
    
    func configureWithNoData() {
        #warning("TODO: implement view model update")
        self.viewModelDidUpdate?()
    }
}
