// swiftlint:disable all
//
//  ContactViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitCommonUI

struct ContactViewModel {
    let title: String
    let description: String
    let buttonTitle: String
    private let contactType: DKContactType
    private weak var diagnosisViewModel: DiagnosisViewModel?

    init(contactType: DKContactType, diagnosisViewModel: DiagnosisViewModel) {
        self.contactType = contactType
        self.diagnosisViewModel = diagnosisViewModel
        self.title = "dk_perm_utils_app_diag_help_request_title".dkPermissionsUtilsLocalized()
        self.description = "dk_perm_utils_app_diag_help_request_text".dkPermissionsUtilsLocalized()
        self.buttonTitle = "dk_perm_utils_app_diag_help_request_button".dkPermissionsUtilsLocalized()
    }

    func contactSupport() {
        self.diagnosisViewModel?.contactSupport(contactType: self.contactType)
    }
}
