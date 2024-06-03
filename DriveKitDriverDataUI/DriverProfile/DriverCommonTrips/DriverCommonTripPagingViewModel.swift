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
import DriveKitCoreModule

class DriverCommonTripPagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DKCommonTripType: DriverCommonTripViewModel] = [:]
    private var commonTripByType: [DKCommonTripType: DKCommonTrip]?
    
    var allPageIds: [DKCommonTripType] {
        [.mostFrequent]
    }
    
    var hasData: Bool {
        guard let pageCount = self.commonTripByType?.count else {
            return false
        }
        
        return pageCount == allPageIds.count
    }
    
    func pageViewModel(for pageId: DKCommonTripType) -> DriverCommonTripViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverCommonTripViewModel(commonTripType: pageId)
            pageViewModels[pageId] = viewModel
            return viewModel
        }
        
        return pageViewModel
    }
    
    func configure(with commonTripByType: [DKCommonTripType: DKCommonTrip]) {
        self.commonTripByType = commonTripByType
        for pageViewModel in pageViewModels.values {
            guard let commonTrip = commonTripByType[pageViewModel.commonTripType] else {
                DriveKitLog.shared.errorLog(
                    tag: DriveKitDriverDataUI.tag,
                    message: "We should have a commonTrip info for each common trip type. (\(pageViewModel.commonTripType) not found!)"
                )
                return self.configureWithNoData()
            }
            pageViewModel.configure(with: commonTrip)
        }
    }
    
    func configureWithNoData() {
        self.commonTripByType = nil
        for pageViewModel in pageViewModels.values {
            pageViewModel.configureWithNoData()
        }
    }
}
