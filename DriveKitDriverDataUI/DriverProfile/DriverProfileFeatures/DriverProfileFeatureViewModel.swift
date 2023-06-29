//
//  DriverProfileFeatureViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation

class DriverProfileFeatureViewModel {
    var driverProfileFeature: DriverProfileFeature
    var viewModelDidUpdate: (() -> Void)?

    init(
        driverProfileFeature: DriverProfileFeature
    ) {
        self.driverProfileFeature = driverProfileFeature
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
