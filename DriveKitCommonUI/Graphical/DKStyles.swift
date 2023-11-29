// swiftlint:disable no_magic_numbers
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
    button,
    roundedButton
    
    public var style: DKStyle {
        var size: CGFloat = 14
        var traits: UIFontDescriptor.SymbolicTraits?
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
            size = 13
            traits = nil
        case .highlightBig:
            size = 30
            traits = .traitBold
        case .highlightNormal:
            size = 22
            traits = .traitBold
        case .highlightSmall:
            size = 16
            traits = .traitBold
        case .button:
            size = 15
            traits = .traitBold
        case .roundedButton:
            size = 20
            traits = nil
        }
        return DKStyle(size: size, traits: traits)
    }

    public func withSizeDelta(_ delta: CGFloat) -> DKStyle {
        let sourceStyle = self.style
        return DKStyle(size: sourceStyle.size + delta, traits: sourceStyle.traits)
    }
}

public struct DKStyle {
    public let size: CGFloat
    let traits: UIFontDescriptor.SymbolicTraits?
    public static let driverDataText = DKStyles.normalText.withSizeDelta(-2)

    public init(size: CGFloat, traits: UIFontDescriptor.SymbolicTraits?) {
        self.size = size
        self.traits = traits
    }
    
    public func applyTo(font: DKUIFonts) -> UIFont {
        let font = UIFont(name: font.name, size: size) ?? UIFont.systemFont(ofSize: size)
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
