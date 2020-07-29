//
//  DriveKitUI.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public class DriveKitUI : NSObject {

    @objc public static let shared = DriveKitUI()

    public var colors: DKColors!
    var fonts: DKFonts!
    var overridedStringFileName: String?

    private override init() {}

    public func initialize(colors: DKColors = DKDefaultColors(), fonts: DKFonts = DKDefaultFonts(), overridedStringsFileName: String? = nil) {
        self.colors = colors
        self.fonts = fonts
        self.overridedStringFileName = overridedStringsFileName
    }

    @objc(initialize) public func objc_initialize() {
        self.colors = DKDefaultColors()
        self.fonts = DKDefaultFonts()
        self.overridedStringFileName = nil
    }

    @objc public func configureColors(_ colors: DKColors) {
        self.colors = colors
    }

    @objc public func configureFonts(_ fonts: DKFonts) {
        self.fonts = fonts
    }

    @objc public func configureStringsFileName(_ overridedStringsFileName: String) {
        self.overridedStringFileName = overridedStringsFileName
    }
}

extension Bundle {
    static let driveKitCommonUIBundle = Bundle(identifier: "com.drivequant.drivekit-common-ui")
}
