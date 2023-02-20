//
//  FeatureType.swift
//  DriveKitApp
//
//  Created by David Bauduin on 25/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

enum FeatureType {
    case all
    case driverData_trips
    case driverData_timeline
    case driverData_my_synthesis
    case permissionsUtils_onboarding
    case permissionsUtils_diagnosis
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
            case .driverData_timeline:
                imageName = "feature_icon_driverdata_timeline"
            case .driverData_my_synthesis:
                #warning("Update with the correct image")
                imageName = "feature_icon_driverdata_timeline"
            case .permissionsUtils_diagnosis, .permissionsUtils_onboarding:
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
            case .driverData_timeline:
                title = "feature_timeline_title"
            case .driverData_my_synthesis:
                title = "feature_synthesis_title"
            case .permissionsUtils_diagnosis:
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
            case .driverData_timeline:
                description = "feature_timeline_description"
            case .driverData_my_synthesis:
                description = "feature_synthesis_description"
            case .permissionsUtils_diagnosis:
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

    func getInfoUrl() -> String? {
        let docKey: String?
        switch self {
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
            case .driverData_timeline:
                docKey = "drivekit_doc_ios_timeline"
            case .driverData_my_synthesis:
                docKey = "drivekit_doc_ios_synthesis"
            case .permissionsUtils_diagnosis:
                docKey = "drivekit_doc_ios_diag"
            case .permissionsUtils_onboarding:
                docKey = "drivekit_doc_ios_permissions_management"
            case .tripAnalysis_workingHours:
                docKey = "drivekit_doc_ios_working_hours"
            case .vehicle_list:
                docKey = "drivekit_doc_ios_vehicle_list"
            case .vehicle_odometer:
                docKey = "drivekit_doc_ios_odometer"
        }
        return docKey?.keyLocalized()
    }

    func getActionButtonTitle() -> String {
        switch self {
            case .all:
                return "button_see_features".keyLocalized()
            case .challenge_list,
                .driverAchievement_badges,
                .driverAchievement_ranking,
                .driverAchievement_streaks,
                .driverData_trips,
                .driverData_timeline,
                .driverData_my_synthesis,
                .permissionsUtils_diagnosis,
                .permissionsUtils_onboarding,
                .tripAnalysis_workingHours,
                .vehicle_list,
                .vehicle_odometer:
                return "button_see_feature".keyLocalized()
        }
    }
}
