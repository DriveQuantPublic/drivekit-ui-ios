//
//  DKFonts.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKFonts {
    func primaryFont() -> String
    func secondaryFont() -> String
}

open class DKDefaultFonts : DKFonts {
    public init() {}

    open func primaryFont() -> String {
        return "Roboto"
    }
    open func secondaryFont() -> String {
        return "Roboto"
    }
}

public enum DKUIFonts {
    case primary, secondary

    public var name: String {
        switch self {
        case .primary:
            return DriveKitUI.shared.fonts.primaryFont()
        case .secondary:
            return DriveKitUI.shared.fonts.secondaryFont()
        }
    }

    public func fonts(size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
