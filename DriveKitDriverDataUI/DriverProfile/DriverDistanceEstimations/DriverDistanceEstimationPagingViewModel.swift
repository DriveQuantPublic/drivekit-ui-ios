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
    var allPageIds: [DKPeriod] {
        [.year, .month, .week]
    }
    
    func pageViewModel(for pageId: DKPeriod) -> DriverDistanceEstimationViewModel? {
        .init(period: pageId)
    }
}
