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
    private let grayColor = UIColor(hex:0x9e9e9e)
    private let darkColor = UIColor(hex: 0x193851)

    func shouldDisplayErrorText() -> Bool {
        if let apiKey = getApiKey(), !apiKey.isEmpty, !apiKey.isKeyPlaceHolder() {
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

extension String {
    fileprivate static let keyPlaceHolderRegEx = "[A-Z]{5}(_[A-Z]{3,5}){4}"
    mutating func replaceApiKeyIfNeeded() {
        if self.isKeyPlaceHolder() {
            let processInfo = ProcessInfo.processInfo
            self = processInfo.environment["DriveKit-API-Key"] ?? DriveKit.shared.config.getApiKey() ?? self
        }
    }
    fileprivate func isKeyPlaceHolder() -> Bool {
        guard let regex = try? NSRegularExpression(pattern: String.keyPlaceHolderRegEx) else {
            return false
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let result: Bool = regex.firstMatch(in: self, range: range) != nil
        return result
    }
}
