//
//  ApiKeyViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 07/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

struct ApiKeyViewModel {
    static let placeHolder = "ENTER_YOUR_API_KEY_HERE"
    private let grayColor = UIColor(hex:0x9e9e9e)
    private let darkColor = UIColor(hex: 0x193851)

    func shouldDisplayErrorText() -> Bool {
        if let apiKey = getApiKey(), !apiKey.isEmpty, apiKey != ApiKeyViewModel.placeHolder {
            return false
        } else {
            return true
        }
    }

    func getApiKey() -> String? {
        return DriveKit.shared.config.getApiKey()
    }

    func getContentAttibutedText() -> NSAttributedString {
        let apiKey = self.getApiKey() ?? ""
        let apiKeyString = apiKey.dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 14, traits: .traitBold)).color(darkColor).build()
        let contentString = "welcome_ok_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 14, traits: nil)).color(grayColor).buildWithArgs(apiKeyString)
        return contentString
    }

    func getApiKeyErrorAttibutedText() -> NSAttributedString {
        return "welcome_ko_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: DKStyle(size: 14, traits: nil)).color(grayColor).build()
    }
}
