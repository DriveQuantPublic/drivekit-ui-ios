//
//  DriverDistanceEstimationPagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 28/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule

class DriverDistanceEstimationPagingViewModel: DKUIPagingViewModel {
    private var pageViewModels: [DKPeriod: DriverDistanceEstimationViewModel] = [:]
    private var driverProfile: DKDriverProfile?
    private var currentDrivenDistances: [DKPeriod: Double] = [:]

    var allPageIds: [DKPeriod] {
        [.year, .month, .week]
    }

    var hasData: Bool {
        return driverProfile != nil && !currentDrivenDistances.isEmpty
    }

    func pageViewModel(for pageId: DKPeriod) -> DriverDistanceEstimationViewModel? {
        guard let pageViewModel = pageViewModels[pageId] else {
            let viewModel = DriverDistanceEstimationViewModel(period: pageId)
            pageViewModels[pageId] = viewModel
            return viewModel
        }
        
        return pageViewModel
    }

    func configure(with driverProfile: DKDriverProfile, and currentDrivenDistances: [DKPeriod: Double]) {
        self.driverProfile = driverProfile
        self.currentDrivenDistances = currentDrivenDistances
        for pageViewModel in pageViewModels.values {
            pageViewModel.configure(with: driverProfile.distanceEstimation, and: currentDrivenDistances)
        }
    }

    func configureWithNoData() {
        for pageViewModel in pageViewModels.values {
            pageViewModel.configureWithNoData()
        }
    }
}
