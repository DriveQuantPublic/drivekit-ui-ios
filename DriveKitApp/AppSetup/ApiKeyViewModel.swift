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
        if let apiKey = DriveKit.shared.config.getApiKey(), !apiKey.isEmpty, apiKey != ApiKeyViewModel.placeHolder {
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
        let contentAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14), NSAttributedString.Key.foregroundColor: grayColor]

        let contentString = String(format: "welcome_ok_description".keyLocalized(), apiKey)
        let attributedContent = NSMutableAttributedString(string: contentString, attributes: contentAttributes)
        let keyRange = (contentString as NSString).range(of: apiKey)
        let keyAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14).with(.traitBold), NSAttributedString.Key.foregroundColor: darkColor]
        attributedContent.setAttributes(keyAttributes, range: keyRange)
        return attributedContent
    }

    func getApiKeyErrorAttibutedText() -> NSAttributedString {
        let contentAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14), NSAttributedString.Key.foregroundColor: grayColor]
        let contentString = "welcome_ko_description".keyLocalized()
        return NSAttributedString(string: contentString, attributes: contentAttributes)
    }

}
