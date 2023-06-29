//
//  DriverProfileFeaturePagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import Foundation

class DriverProfileFeaturePagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DriverProfileFeature: DriverProfileFeatureViewModel] = [:]
    
    var allPageIds: [DriverProfileFeature] {
        DriverProfileFeature.allCases
    }
    
    func pageViewModel(for pageId: DriverProfileFeature) -> DriverProfileFeatureViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverProfileFeatureViewModel(driverProfileFeature: pageId)
            pageViewModels[pageId] = viewModel
            return viewModel
        }
        
        return pageViewModel
    }
    
    func configure() {
        for pageViewModel in pageViewModels.values {
            pageViewModel.configure()
        }
    }
    
    func configureWithNoData() {
        for pageViewModel in pageViewModels.values {
            pageViewModel.configureWithNoData()
        }
    }
}
