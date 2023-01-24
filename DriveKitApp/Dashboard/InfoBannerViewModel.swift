// swiftlint:disable all
//
//  InfoBannerViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 10/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitPermissionsUtilsUI

class InfoBannerViewModel {
    private let type: InfoBannerType

    init(type: InfoBannerType) {
        self.type = type
    }

    var shouldDisplay: Bool {
        return self.type.shouldDisplay
    }

    var color: UIColor {
        return self.type.color
    }

    var backgroundColor: UIColor {
        return self.type.backgroundColor
    }

    var icon: UIImage? {
        return self.type.icon
    }

    var title: String {
        return self.type.title
    }

    var hasAction: Bool {
        return self.type.hasAction
    }

    func showAction(parentViewController: UIViewController) {
        if self.type.hasAction {
            switch self.type {
                case .diagnosis:
                    let diagnosisVC = DriveKitPermissionsUtilsUI.shared.getDiagnosisViewController()
                    parentViewController.navigationController?.show(diagnosisVC, sender: nil)
            }
        }
    }
}
