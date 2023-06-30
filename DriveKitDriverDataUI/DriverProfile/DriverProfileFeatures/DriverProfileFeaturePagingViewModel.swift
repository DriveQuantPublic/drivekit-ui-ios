//
//  DriverProfileFeaturePagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation

class DriverProfileFeaturePagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DriverProfileFeature: DriverProfileFeatureViewModel] = [:]
    var driverProfile: DKDriverProfile?
    
    var allPageIds: [DriverProfileFeature] {
        DriverProfileFeature.allCases
    }
    
    var hasData: Bool {
        return driverProfile != nil
    }
    
    func pageViewModel(for pageId: DriverProfileFeature) -> DriverProfileFeatureViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverProfileFeatureViewModel(driverProfileFeature: pageId)
            if let driverProfile {
                viewModel.configure(with: driverProfile)
            } else {
                viewModel.configureWithNoData()
            }
            pageViewModels[pageId] = viewModel
            return viewModel
        }
        
        return pageViewModel
    }
    
    func configure(with driverProfile: DKDriverProfile) {
        self.driverProfile = driverProfile
        for pageViewModel in pageViewModels.values {
            pageViewModel.configure(with: driverProfile)
        }
    }
    
    func configureWithNoData() {
        self.driverProfile = nil
        for pageViewModel in pageViewModels.values {
            pageViewModel.configureWithNoData()
        }
    }
}
