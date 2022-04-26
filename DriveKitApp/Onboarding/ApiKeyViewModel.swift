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
    private let darkColor = UIColor(hex: 0x193851)

    var invalidApiKeyErrorReceived: Bool

    init(invalidApiKeyErrorReceived: Bool = false) {
        self.invalidApiKeyErrorReceived = invalidApiKeyErrorReceived
    }

    func shouldDisplayErrorText() -> Bool {
        if let apiKey = getApiKey(), !apiKey.isEmpty, !apiKey.isKeyPlaceHolder() {
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

extension String {
    fileprivate static let keyPlaceHolderRegEx = "[A-Z]{5}(_[A-Z]{3,4}){4}"
    mutating func replaceApiKeyIfNeeded() {
        if self.isKeyPlaceHolder() {
            let processInfo = ProcessInfo.processInfo
            self = processInfo.environment["DriveKit-API-Key"] ?? DriveKit.shared.config.getApiKey() ?? self
        }
    }
    fileprivate func isKeyPlaceHolder() -> Bool {
        return range(of: String.keyPlaceHolderRegEx, options: .regularExpression) != nil
    }
}
