//
//  DKFonts.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public protocol DKFonts {
    @objc var primaryFont : String { get }
    @objc var secondaryFont : String { get }
}

public class DKDefaultFonts :  DKFonts {
    public init() {}
    public var primaryFont : String { get { return "Roboto" }}
    public var secondaryFont : String { get { return "Roboto" }}
}

public enum DKUIFonts {
    case primary, secondary
    
    var name : String {
        switch self{
        case .primary:
            return DriveKitUI.shared.fonts.primaryFont
        case .secondary:
            return DriveKitUI.shared.fonts.secondaryFont
        }
    }
    
    /*public func primaryFont(size: CGFloat) -> UIFont {
        return UIFont(name: fonts.primaryFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    public func secondaryFont(size: CGFloat) -> UIFont {
        return UIFont(name: fonts.secondaryFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    public func primaryFont(style: DKStyles) -> UIFont {
        let font = UIFont(name: fonts.primaryFont, size: style.style.size) ?? UIFont.systemFont(ofSize: style.style.size)
        return applyTraits(font: font, traits: style.style.traits)
    }
    
    public func secondaryFont(style: DKStyles) -> UIFont {
        let font =  UIFont(name: fonts.secondaryFont, size: style.style.size) ?? UIFont.systemFont(ofSize: style.style.size)
        return applyTraits(font: font, traits: style.style.traits)
    }
    
    public func primaryFont(style: DKStyle) -> UIFont {
        let font = UIFont(name: fonts.primaryFont, size: style.size) ?? UIFont.systemFont(ofSize: style.size)
        return applyTraits(font: font, traits: style.traits)
    }
    
    public func secondaryFont(style: DKStyle) -> UIFont {
        let font =  UIFont(name: fonts.secondaryFont, size: style.size) ?? UIFont.systemFont(ofSize: style.size)
        return applyTraits(font: font, traits: style.traits)
    }*/
    
    
    
}
