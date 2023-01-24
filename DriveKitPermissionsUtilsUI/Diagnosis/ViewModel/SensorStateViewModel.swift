//
//  SensorStateViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

struct SensorStateViewModel {
    let title: String
    let statusIcon: UIImage?
    let statusIconTintColor: UIColor
    let learnMoreText: String
    weak var diagnosisViewModel: DiagnosisViewModel?
    private let statusType: StatusType
    private let isValid: Bool

    init(statusType: StatusType, valid: Bool, diagnosisViewModel: DiagnosisViewModel) {
        self.statusType = statusType
        self.isValid = valid
        self.diagnosisViewModel = diagnosisViewModel
        self.title = statusType.getTitle()

        let icon: UIImage?
        if valid {
            icon = DKPermissionsUtilsImages.checkedGeneric.image
            self.statusIconTintColor = UIColor.dkValid
        } else {
            icon = DKPermissionsUtilsImages.highPriorityGeneric.image
            self.statusIconTintColor = DKUIColors.criticalColor.color
        }
        self.statusIcon = icon?.withRenderingMode(.alwaysTemplate)

        self.learnMoreText = "dk_perm_utils_app_diag_learn_more".dkPermissionsUtilsLocalized()
    }

    func showDialog() {
        self.diagnosisViewModel?.showDialog(for: self.statusType, isValid: self.isValid)
    }
}
