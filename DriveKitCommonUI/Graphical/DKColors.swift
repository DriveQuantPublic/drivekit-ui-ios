//
//  DKColors.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKColors {
    @objc var primaryColor : UIColor { get }
    @objc var secondaryColor : UIColor { get }
    @objc var mainFontColor : UIColor { get }
    @objc var complementaryFontColor : UIColor { get }
    @objc var fontColorOnPrimaryColor : UIColor { get }
    @objc var fontColorOnSecondaryColor : UIColor { get }
    @objc var warningColor : UIColor { get }
    @objc var criticalColor : UIColor { get }
    @objc var neutralColor : UIColor { get }
    @objc var backgroundViewColor : UIColor { get }
}

public class DKDefaultColors : DKColors {
    
    public init() {}
    public var primaryColor : UIColor { get { return UIColor(hex:0x0B4D6E) }}
    public var secondaryColor : UIColor { get { return UIColor(hex: 0x77E2B2) }}
    public var mainFontColor : UIColor { get { return UIColor(hex: 0x616161) }}
    public var complementaryFontColor : UIColor { get { UIColor(hex: 0x9E9E9E) }}
    public var fontColorOnPrimaryColor : UIColor { get { return UIColor.white }}
    public var fontColorOnSecondaryColor : UIColor { get { return UIColor.white }}
    public var warningColor : UIColor { get { return UIColor(hex: 0xff6e57) }}
    public var criticalColor : UIColor { get { return UIColor(hex: 0xE52027) }}
    public var neutralColor: UIColor { get { return UIColor(hex: 0xF0F0F0) }}
    public var backgroundViewColor: UIColor { get { return UIColor(hex: 0xFAFAFA) }}
}

public enum DKUIColors {
    case primaryColor,
    secondaryColor,
    mainFontColor,
    complementaryFontColor,
    fontColorOnPrimaryColor,
    fontColorOnSecondar,
    warningColor,
    criticalColor,
    neutralColor,
    backgroundView
    
    public var color : UIColor {
        switch self {
        case .primaryColor:
            return DriveKitUI.shared.colors.primaryColor
        case .secondaryColor:
            return DriveKitUI.shared.colors.secondaryColor
        case .mainFontColor:
            return DriveKitUI.shared.colors.mainFontColor
        case .complementaryFontColor:
            return DriveKitUI.shared.colors.complementaryFontColor
        case .fontColorOnPrimaryColor:
            return DriveKitUI.shared.colors.fontColorOnPrimaryColor
        case .fontColorOnSecondar:
            return DriveKitUI.shared.colors.fontColorOnSecondaryColor
        case .warningColor:
            return DriveKitUI.shared.colors.warningColor
        case .criticalColor:
            return DriveKitUI.shared.colors.criticalColor
        case .neutralColor:
            return DriveKitUI.shared.colors.neutralColor
        case .backgroundView:
            return DriveKitUI.shared.colors.backgroundViewColor
        }
    }
}
