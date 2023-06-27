//
//  DriverProfileFeaturePagingViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 27/06/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import Foundation

class DriverProfileFeaturePagingViewModel: DKUIPagingCardViewModel {
    var allPageIds: [DriverProfileFeature] {
        DriverProfileFeature.allCases
    }
    
    func pageViewModel(for pageId: DriverProfileFeature) -> DriverProfileFeatureViewModel? {
        nil
    }
}
