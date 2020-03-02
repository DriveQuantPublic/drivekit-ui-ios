//
//  DKStyles.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum DKStyles {
    case headLine1,
    headLine2,
    normalText,
    bigtext,
    smallText,
    highlightBig,
    highlightNormal,
    highlightSmall,
    button
    
    var style : DKStyle {
        var size : CGFloat = 14
        var traits : UIFontDescriptor.SymbolicTraits? = nil
        switch self {
        case .headLine1:
            size = 18
            traits = .traitBold
        case .headLine2:
            size = 16
            traits = .traitBold
        case .normalText:
            size = 16
            traits = nil
        case .bigtext:
            size = 18
            traits = nil
        case .smallText:
            size = 12
            traits = nil
        case .highlightBig:
            size = 48
            traits = .traitBold
        case .highlightNormal:
            size = 34
            traits = .traitBold
        case .highlightSmall:
            size = 24
            traits = .traitBold
        case .button:
            size = 18
            traits = .traitBold
        }
        return DKStyle(size: size, traits: traits)
    }
}

public struct DKStyle {
    let size: CGFloat
    let traits: UIFontDescriptor.SymbolicTraits?
    
    public init(size : CGFloat, traits: UIFontDescriptor.SymbolicTraits?) {
        self.size = size
        self.traits = traits
    }
    
    public func applyTo(font: DKUIFonts) -> UIFont {
        let font =  UIFont(name: font.name, size: size) ?? UIFont.systemFont(ofSize: size)
        return applyTraits(font: font)
    }
    
    private func applyTraits(font: UIFont) -> UIFont {
        if let traits = traits {
            return font.with(traits)
        } else {
            return font
        }
    }
}
