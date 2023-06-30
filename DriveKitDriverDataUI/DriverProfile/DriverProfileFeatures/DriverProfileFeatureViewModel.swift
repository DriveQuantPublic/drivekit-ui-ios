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
    var driverProfile: DKDriverProfile?
    var viewModelDidUpdate: (() -> Void)?

    init(
        driverProfileFeature: DriverProfileFeature
    ) {
        self.driverProfileFeature = driverProfileFeature
    }
    
    func configure(with driverProfile: DKDriverProfile) {
        self.driverProfile = driverProfile
        self.viewModelDidUpdate?()
    }
    
    func configureWithNoData() {
        self.driverProfile = nil
        self.viewModelDidUpdate?()
    }
    
    var title: String {
        guard let driverProfile else {
            return "dk_driverdata_profile_empty_card_title".dkDriverDataLocalized()
        }
        return driverProfileFeature.title(for: driverProfile)
    }
    
    var descriptionText: String {
        guard let driverProfile else {
            return "dk_driverdata_profile_empty_card_text".dkDriverDataLocalized()
        }
        return driverProfileFeature.descriptionText(for: driverProfile)
    }
    
    var iconName: String {
        guard driverProfile != nil else {
            return "dk_profile_empty"
        }
        return driverProfileFeature.iconName
    }
}
