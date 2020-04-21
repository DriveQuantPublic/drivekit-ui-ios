//
//  ContactViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

struct ContactViewModel {
    let title: String
    let description: String
    let buttonTitle: String
    private let contactType: DKContactType

    init(contactType: DKContactType) {
        self.title = "dk_perm_utils_app_diag_help_request_title".dkPermissionsUtilsLocalized()
        self.description = "dk_perm_utils_app_diag_help_request_text".dkPermissionsUtilsLocalized()
        self.buttonTitle = "dk_perm_utils_app_diag_help_request_button".dkPermissionsUtilsLocalized()
        self.contactType = contactType
    }
}
