//
//  DKColors.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKColors {
    func primaryColor() -> UIColor
    func secondaryColor() -> UIColor
    func mainFontColor() -> UIColor
    func complementaryFontColor() -> UIColor
    func fontColorOnPrimaryColor() -> UIColor
    func fontColorOnSecondaryColor() -> UIColor
    func warningColor() -> UIColor
    func criticalColor() -> UIColor
    func neutralColor() -> UIColor
    func backgroundViewColor() -> UIColor
}

open class DKDefaultColors : DKColors {
    public init() {}

    open func primaryColor() -> UIColor {
        return UIColor(hex:0x0B4D6E)
    }
    open func secondaryColor() -> UIColor {
        return UIColor(hex: 0x00EBB8)
    }
    open func mainFontColor() -> UIColor {
        return UIColor(hex: 0x161616)
    }
    open func complementaryFontColor() -> UIColor {
        return UIColor(hex: 0x555555)
    }
    open func fontColorOnPrimaryColor() -> UIColor {
        return UIColor.white
    }
    open func fontColorOnSecondaryColor() -> UIColor {
        return UIColor.white
    }
    open func warningColor() -> UIColor {
        return UIColor(hex: 0xff6e57)
    }
    open func criticalColor() -> UIColor {
        return UIColor(hex: 0xE52027)
    }
    open func neutralColor() -> UIColor {
        return UIColor(hex: 0xF0F0F0)
    }
    open func backgroundViewColor() -> UIColor {
        return UIColor(hex: 0xFAFAFA)
    }
}

public enum DKUIColors {
    case primaryColor,
    secondaryColor,
    mainFontColor,
    complementaryFontColor,
    fontColorOnPrimaryColor,
    fontColorOnSecondaryColor,
    warningColor,
    criticalColor,
    neutralColor,
    backgroundView

    public var color: UIColor {
        switch self {
        case .primaryColor:
            return DriveKitUI.shared.colors.primaryColor()
        case .secondaryColor:
            return DriveKitUI.shared.colors.secondaryColor()
        case .mainFontColor:
            return DriveKitUI.shared.colors.mainFontColor()
        case .complementaryFontColor:
            return DriveKitUI.shared.colors.complementaryFontColor()
        case .fontColorOnPrimaryColor:
            return DriveKitUI.shared.colors.fontColorOnPrimaryColor()
        case .fontColorOnSecondaryColor:
            return DriveKitUI.shared.colors.fontColorOnSecondaryColor()
        case .warningColor:
            return DriveKitUI.shared.colors.warningColor()
        case .criticalColor:
            return DriveKitUI.shared.colors.criticalColor()
        case .neutralColor:
            return DriveKitUI.shared.colors.neutralColor()
        case .backgroundView:
            return DriveKitUI.shared.colors.backgroundViewColor()
        }
    }
}
