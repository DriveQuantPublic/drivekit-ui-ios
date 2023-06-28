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
    var allPageIds: [DKCommonTripType] {
        [.mostFrequent]
    }
    
    func pageViewModel(for pageId: DKCommonTripType) -> DriverCommonTripViewModel? {
        .init(commonTripType: pageId)
    }
}
