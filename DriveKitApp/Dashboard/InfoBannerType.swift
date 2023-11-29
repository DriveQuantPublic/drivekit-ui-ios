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

enum InfoBannerType: CaseIterable {
    case diagnosis

    var shouldDisplay: Bool {
        switch self {
            case .diagnosis:
                return DriveKitPermissionsUtilsUI.shared.hasError()
        }
    }

    var color: UIColor {
        switch self {
            case .diagnosis:
                return .white
        }
    }

    var backgroundColor: UIColor {
        switch self {
            case .diagnosis:
                return DKUIColors.warningColor.color
        }
    }

    var icon: UIImage? {
        switch self {
            case .diagnosis:
                return UIImage(named: "dashboard_banner_diagnosis_icon")
        }
    }

    var title: String {
        switch self {
            case .diagnosis:
                return "info_banner_diagnosis_title".keyLocalized()
        }
    }

    var hasAction: Bool {
        switch self {
            case .diagnosis:
                return true
        }
    }
}
