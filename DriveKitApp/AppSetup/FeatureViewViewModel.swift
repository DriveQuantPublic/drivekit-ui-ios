//
//  FeatureViewViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDriverDataUI
import DriveKitPermissionsUtilsUI
import DriveKitVehicleUI

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

    func showInfo(parentViewController: UIViewController) {
        let docKey: String?
        switch self.type {
            case .all:
                docKey = nil
            case .challenge_list:
                docKey = "drivekit_doc_ios_challenges"
            case .driverAchievement_badges:
                docKey = "drivekit_doc_ios_badges"
            case .driverAchievement_ranking:
                docKey = "drivekit_doc_ios_ranking"
            case .driverAchievement_streaks:
                docKey = "drivekit_doc_ios_streaks"
            case .driverData_trips:
                docKey = "drivekit_doc_ios_driver_data"
            case .permissionsUtils_diagnostic:
                docKey = "drivekit_doc_ios_diag"
            case .permissionsUtils_onboarding:
                docKey = "drivekit_doc_ios_permission_management"
            case .tripAnalysis_workingHours:
                docKey = "drivekit_doc_ios_working_hours"
            case .vehicle_list:
                docKey = "drivekit_doc_ios_vehicle_list"
            case .vehicle_odometer:
                docKey = "drivekit_doc_ios_odometer"
        }
        if let docKey = docKey, let docURL = URL(string: docKey.keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    func executeAction(parentViewController: UIViewController) {
        let viewController: UIViewController?
        switch self.type {
            case .all:
                viewController = FeaturesViewController()
            case .challenge_list:
                if let challengeUI = DriveKitNavigationController.shared.challengeUI {
                    viewController = challengeUI.getChallengeListViewController()
                } else {
                    viewController = nil
                }
            case .driverAchievement_badges:
                if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
                    viewController = driverAchievementUI.getBadgesViewController()
                } else {
                    viewController = nil
                }
            case .driverAchievement_ranking:
                if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
                    viewController = driverAchievementUI.getRankingViewController()
                } else {
                    viewController = nil
                }
            case .driverAchievement_streaks:
                if let driverAchievementUI = DriveKitNavigationController.shared.driverAchievementUI {
                    viewController = driverAchievementUI.getStreakViewController()
                } else {
                    viewController = nil
                }
            case .driverData_trips:
                viewController = TripListVC()
            case .permissionsUtils_diagnostic:
                viewController = DriveKitPermissionsUtilsUI.shared.getDiagnosisViewController()
            case .permissionsUtils_onboarding:
                // feature_permission_onboarding_ok
                if DriveKitPermissionsUtilsUI.shared.isPermissionViewValid(.location) && DriveKitPermissionsUtilsUI.shared.isPermissionViewValid(.activity) {
                    parentViewController.showAlertMessage(title: nil, message: "feature_permission_onboarding_ok".keyLocalized(), back: false, cancel: false)
                } else {
                    DriveKitPermissionsUtilsUI.shared.showPermissionViews([.location, .activity], parentViewController: parentViewController) {
                        // Nothing to do.
                    }
                }
                viewController = nil
            case .tripAnalysis_workingHours:
                if let tripAnalysisUI = DriveKitNavigationController.shared.tripAnalysisUI {
                    viewController = tripAnalysisUI.getWorkingHoursViewController()
                } else {
                    viewController = nil
                }
            case .vehicle_list:
                viewController = VehiclesListVC()
            case .vehicle_odometer:
                viewController = DriveKitVehicleUI.shared.getOdometerUI()
        }
        if let viewController = viewController {
            parentViewController.navigationController?.pushViewController(viewController, animated: true)
        }
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
        let imageName: String?
        switch self {
            case .all:
                imageName = nil
            case .challenge_list:
                imageName = "feature_icon_challenge"
            case .driverAchievement_badges:
                imageName = "feature_icon_driverData_badges"
            case .driverAchievement_ranking:
                imageName = "feature_icon_driverData_ranking"
            case .driverAchievement_streaks:
                imageName = "feature_icon_driverData_streaks"
            case .driverData_trips:
                imageName = "feature_icon_driverData_trips"
            case .permissionsUtils_diagnostic, .permissionsUtils_onboarding:
                imageName = "feature_icon_permissionsUtils"
            case .tripAnalysis_workingHours:
                imageName = "feature_icon_tripAnalysis_workingHours"
            case .vehicle_list, .vehicle_odometer:
                imageName = "feature_icon_vehicle"
        }
        if let imageName = imageName {
            return UIImage(named: imageName)
        } else {
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
