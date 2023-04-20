// swiftlint:disable all
//
//  BatteryOptimizationViewModel.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 22/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

class BatteryOptimizationViewModel {
    var title: NSAttributedString {
        "dk_perm_utils_energy_saver_title".dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .headLine1)
            .color(.mainFontColor)
            .build()
    }
    
    var description: NSAttributedString {
        "dk_perm_utils_energy_saver_iOS_main".dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .smallText)
            .color(.complementaryFontColor)
            .buildWithArgs(
                "dk_perm_utils_energy_saver_iOS_link_text".dkPermissionsUtilsLocalized()
                    .dkAttributedString()
                    .font(dkFont: .primary, style: .smallText)
                    .color(.secondaryColor)
                    .build()
            )
    }
    var action: String {
        "dk_perm_utils_brand_apple".dkPermissionsUtilsLocalized()
    }

    init() {}

    func performAction() {
        guard let url = URL(string: self.action) else { return }
        DKDiagnosisHelper.shared.openUrl(url)
    }
}
