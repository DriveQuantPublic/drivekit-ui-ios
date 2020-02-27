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
    
    public var colors : DKColors!
    private var fonts : DKFonts!
    var overridedStringFileName : String?
    
    private override init() {}
    
    @objc public func initialize(colors : DKColors = DKDefaultColors(), fonts: DKFonts = DKDefaultFonts(), overridedStringsFileName : String? = nil) {
        self.colors = colors
        self.fonts = fonts
        self.overridedStringFileName = overridedStringsFileName
    }
    
    @objc public func primaryFont(size: CGFloat) -> UIFont {
        return UIFont(name: fonts.primaryFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    @objc public func secondaryFont(size: CGFloat) -> UIFont {
        return UIFont(name: fonts.secondaryFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
