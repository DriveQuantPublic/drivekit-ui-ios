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
    private let invalidApiKeyErrorReceived: Bool
    private let darkColor = UIColor(hex: 0x193851)

    init(invalidApiKeyErrorReceived: Bool = false) {
        self.invalidApiKeyErrorReceived = invalidApiKeyErrorReceived
    }

    func shouldDisplayErrorText() -> Bool {
        if let apiKey = getApiKey(), !apiKey.isEmpty {
            return invalidApiKeyErrorReceived
        } else {
            return true
        }
    }

    func getApiKey() -> String? {
        return DriveKit.shared.config.getApiKey()
    }

    func getContentAttibutedText() -> NSAttributedString {
        let apiKey = self.getApiKey() ?? ""
        let apiKeyString = apiKey.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(darkColor).build()
        let contentString = "welcome_ok_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).buildWithArgs(apiKeyString)
        return contentString
    }

    func getApiKeyErrorTitle() -> String {
        if invalidApiKeyErrorReceived {
            return "welcome_invalid_key_title".keyLocalized()
        } else {
            return "welcome_ko_title".keyLocalized()
        }
    }
    func getApiKeyErrorAttibutedText() -> NSAttributedString {
        return "welcome_ko_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }
}
