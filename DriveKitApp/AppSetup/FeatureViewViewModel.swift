//
//  FeatureViewViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

class FeatureViewViewModel {
    private let type: FeatureType

    init(type: FeatureType) {
        self.type = type
    }

    func getIcon() -> UIImage? {
        return self.type.getIcon()
    }

    func getTitle() -> String {
        return self.type.getTitle()
    }

    func getDescription() -> String {
        return self.type.getDescription()
    }

    func getActionButtonTitle() -> String {
        return self.type.getActionButtonTitle()
    }

    func hasInfo() -> Bool {
        return self.type.hasInfo()
    }

    func showInfo(viewController: UIViewController) {
        #warning("TODO")
        let docKey: String?
        switch self.type {
            case .all:
                docKey = nil
            case .challenge_list:
                docKey = nil
            case .driverAchievement_badges:
                docKey = nil
            case .driverAchievement_ranking:
                docKey = nil
            case .driverAchievement_streaks:
                docKey = nil
            case .driverData_trips:
                docKey = nil
            case .permissionsUtils_diagnostic:
                docKey = nil
            case .permissionsUtils_onboarding:
                docKey = nil
            case .tripAnalysis_workingHours:
                docKey = nil
            case .vehicle_list:
                docKey = nil
            case .vehicle_odometer:
                docKey = nil
        }
        if let docKey = docKey, let docURL = URL(string: docKey.keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    func executeAction(parentViewController: UIViewController) {
        #warning("TODO")
        print("TODO: executeAction for type: \(self.type)")
        viewController.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

enum FeatureType {
    case all
    case driverData_trips
    case permissionsUtils_onboarding
    case permissionsUtils_diagnostic
    case vehicle_list
    case vehicle_odometer
    case challenge_list
    case driverAchievement_ranking
    case driverAchievement_badges
    case driverAchievement_streaks
    case tripAnalysis_workingHours

    func getIcon() -> UIImage? {
        #warning("TODO")
        switch self {
            case .all:
                return nil
            case .challenge_list:
                return nil
            case .driverAchievement_badges:
                return nil
            case .driverAchievement_ranking:
                return nil
            case .driverAchievement_streaks:
                return nil
            case .driverData_trips:
                return nil
            case .permissionsUtils_diagnostic:
                return nil
            case .permissionsUtils_onboarding:
                return nil
            case .tripAnalysis_workingHours:
                return nil
            case .vehicle_list:
                return nil
            case .vehicle_odometer:
                return nil
        }
    }

    func getTitle() -> String {
        let title: String
        switch self {
            case .all:
                title = "feature_list"
            case .challenge_list:
                title = "feature_challenges_title"
            case .driverAchievement_badges:
                title = "feature_badges_title"
            case .driverAchievement_ranking:
                title = "feature_ranking_title"
            case .driverAchievement_streaks:
                title = "feature_streaks_title"
            case .driverData_trips:
                title = "feature_trip_list_title"
            case .permissionsUtils_diagnostic:
                title = "feature_permission_utils_title"
            case .permissionsUtils_onboarding:
                title = "feature_permission_utils_onboarding_title"
            case .tripAnalysis_workingHours:
                title = "feature_working_hours_title"
            case .vehicle_list:
                title = "feature_vehicle_title"
            case .vehicle_odometer:
                title = "feature_vehicle_odometer_title"
        }
        return title.keyLocalized()
    }

    func getDescription() -> String {
        let description: String
        switch self {
            case .all:
                description = "feature_list_description"
            case .challenge_list:
                description = "feature_challenges_description"
            case .driverAchievement_badges:
                description = "feature_badges_description"
            case .driverAchievement_ranking:
                description = "feature_ranking_description"
            case .driverAchievement_streaks:
                description = "feature_streaks_description"
            case .driverData_trips:
                description = "feature_trip_list_description"
            case .permissionsUtils_diagnostic:
                description = "feature_permission_utils_description"
            case .permissionsUtils_onboarding:
                description = "feature_permission_utils_onboarding_description"
            case .tripAnalysis_workingHours:
                description = "feature_working_hours_description"
            case .vehicle_list:
                description = "feature_vehicle_description"
            case .vehicle_odometer:
                description = "feature_vehicle_odometer_description"
        }
        return description.keyLocalized()
    }

    func getActionButtonTitle() -> String {
        switch self {
            case .all:
                return "button_see_features".keyLocalized()
            case .challenge_list, .driverAchievement_badges, .driverAchievement_ranking, .driverAchievement_streaks, .driverData_trips, .permissionsUtils_diagnostic, .permissionsUtils_onboarding, .tripAnalysis_workingHours, .vehicle_list, .vehicle_odometer:
                return "button_see_feature".keyLocalized()
        }
    }

    func hasInfo() -> Bool {
        switch self {
            case .all:
                return false
            case .challenge_list, .driverAchievement_badges, .driverAchievement_ranking, .driverAchievement_streaks, .driverData_trips, .permissionsUtils_diagnostic, .permissionsUtils_onboarding, .tripAnalysis_workingHours, .vehicle_list, .vehicle_odometer:
                return true
        }
    }
}
