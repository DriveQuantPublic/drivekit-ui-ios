//
//  DriverCommonTripPagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitDBTripAccessModule
import Foundation

class DriverCommonTripPagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DKCommonTripType: DriverCommonTripViewModel] = [:]
    
    var allPageIds: [DKCommonTripType] {
        [.mostFrequent]
    }
    
    var hasData: Bool {
        #warning("TODO: implement correct behavior")
        return true
    }
    
    func pageViewModel(for pageId: DKCommonTripType) -> DriverCommonTripViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverCommonTripViewModel(commonTripType: pageId)
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
