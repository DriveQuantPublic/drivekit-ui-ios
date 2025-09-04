//
//  InfoBannerType.swift
//  DriveKitApp
//
//  Created by David Bauduin on 10/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitPermissionsUtilsUI
import DriveKitDriverDataUI
import DriveKitDBTripAccessModule

enum InfoBannerType: CaseIterable {
    case diagnosis, driverPassenger

    var shouldDisplay: Bool {
        switch self {
            case .diagnosis:
                return DriveKitPermissionsUtilsUI.shared.hasError()
            case .driverPassenger:
                if DashboardViewModel.alreadyOpenedDriverPassengerMode {
                    return false
                } else {
                    let hasTripsDetectedAsPassenger =
                    !DriveKitDBTripAccess.shared.tripsQuery()
                        .whereEqualTo(field: "occupantInfo.role", value: "PASSENGER")
                        .and()
                        .whereNil(field: "declaredTransportationMode")
                        .query()
                        .execute()
                        .isEmpty
                    return hasTripsDetectedAsPassenger
                }
        }
    }

    var color: UIColor {
        switch self {
            case .diagnosis, .driverPassenger:
                return .white
        }
    }

    var backgroundColor: UIColor {
        switch self {
            case .diagnosis:
                return DKUIColors.warningColor.color
            case .driverPassenger:
                return DKUIColors.informationColor.color
        }
    }

    var icon: UIImage? {
        switch self {
            case .diagnosis:
                return UIImage(named: "dashboard_banner_diagnosis_icon")
            case .driverPassenger:
                return DKDriverDataImages.passengerDeclaration.image?.withRenderingMode(.alwaysTemplate)
        }
    }

    var title: String {
        switch self {
            case .diagnosis:
                return "info_banner_diagnosis_title".keyLocalized()
            case .driverPassenger:
                return "passenger_declaration_banner".keyLocalized()
        }
    }

    var hasAction: Bool {
        switch self {
            case .diagnosis, .driverPassenger:
                return true
        }
    }
}
