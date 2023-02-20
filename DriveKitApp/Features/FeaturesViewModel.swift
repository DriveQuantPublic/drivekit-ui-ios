// swiftlint:disable all
//
//  FeaturesViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 18/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

class FeaturesViewModel {
    let featureViewViewModels: [FeatureViewViewModel] = [
        FeatureViewViewModel(type: .driverData_trips),
        FeatureViewViewModel(type: .driverData_timeline),
        FeatureViewViewModel(type: .driverData_my_synthesis),
        FeatureViewViewModel(type: .permissionsUtils_onboarding),
        FeatureViewViewModel(type: .permissionsUtils_diagnosis),
        FeatureViewViewModel(type: .vehicle_list),
        FeatureViewViewModel(type: .vehicle_odometer),
        FeatureViewViewModel(type: .challenge_list),
        FeatureViewViewModel(type: .driverAchievement_ranking),
        FeatureViewViewModel(type: .driverAchievement_badges),
        FeatureViewViewModel(type: .driverAchievement_streaks),
        FeatureViewViewModel(type: .tripAnalysis_workingHours)
    ]
}
