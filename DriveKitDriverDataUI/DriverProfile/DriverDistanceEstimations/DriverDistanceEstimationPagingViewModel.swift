//
//  DriverDistanceEstimationPagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import Foundation

class DriverDistanceEstimationPagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DKPeriod: DriverDistanceEstimationViewModel] = [:]
    
    var allPageIds: [DKPeriod] {
        [.year, .month, .week]
    }
    
    var hasData: Bool {
        #warning("TODO: implement correct behavior")
        return true
    }
    
    func pageViewModel(for pageId: DKPeriod) -> DriverDistanceEstimationViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverDistanceEstimationViewModel(period: pageId)
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
