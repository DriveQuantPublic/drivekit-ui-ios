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
}

public class DKDefaultColors : DKColors {
    public init() {}
    public var primaryColor : UIColor { get { return UIColor(hex:0x0B4D6E) }}
    public var secondaryColor : UIColor { get { return UIColor(hex: 0x00EBB8) }}
    public var mainFontColor : UIColor { get { return UIColor(hex: 0x616161) }}
    public var complementaryFontColor : UIColor { get { UIColor(hex: 0x9E9E9E) }}
    public var fontColorOnPrimaryColor : UIColor { get { return UIColor.white }}
    public var fontColorOnSecondaryColor : UIColor { get { return UIColor.white }}
    public var warningColor : UIColor { get { return UIColor(hex: 0xff6e57) }}
    public var criticalColor : UIColor { get { return UIColor(hex: 0xf2a365) }}
}
