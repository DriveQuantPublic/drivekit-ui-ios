//
//  FeatureViewViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule
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
        return self.type.getInfoUrl() != nil
    }

    func showInfo(parentViewController: UIViewController) {
        if let infoUrl = self.type.getInfoUrl(), let docURL = URL(string: infoUrl) {
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
            case .driverData_timeline:
                if let driverDataTimelineUI = DriveKitNavigationController.shared.driverDataTimelineUI {
                    viewController = driverDataTimelineUI.getTimelineViewController()
                } else {
                    viewController = nil
                }
            case .permissionsUtils_diagnosis:
                viewController = DriveKitPermissionsUtilsUI.shared.getDiagnosisViewController()
            case .permissionsUtils_onboarding:
                if DKDiagnosisHelper.shared.isLocationValid() && DKDiagnosisHelper.shared.isActivityValid() {
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
