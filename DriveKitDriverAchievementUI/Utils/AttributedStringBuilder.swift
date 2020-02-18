//
//  AttributedStringBuilder.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 17/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

extension String {
    func dkAttributedString() -> AttributedStringBuilder {
        return AttributedStringBuilder(text: self)
    }
}

class AttributedStringBuilder {
    
    private let text : String
    var attributes : [NSAttributedString.Key: Any] = [:]
    
    init(text: String) {
        self.text = text
    }
    
    func color(_ color: UIColor) -> AttributedStringBuilder{
        attributes[.foregroundColor] = color
        return self
    }
    
    func font(_ font : UIFont) -> AttributedStringFont {
        attributes[.font] = font
        return AttributedStringFont(attributedStringBuilder: self, font: font)
    }
    
    func build() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}

class AttributedStringFont {
 
    private let attributedStringBuilder : AttributedStringBuilder
    private let font : UIFont
    
    init(attributedStringBuilder : AttributedStringBuilder, font: UIFont) {
        self.attributedStringBuilder = attributedStringBuilder
        self.font = font
    }
    
    func bold() -> AttributedStringBuilder{
        attributedStringBuilder.attributes[.font] = font.bold
        return attributedStringBuilder
    }
    
    func italic() -> AttributedStringBuilder{
        attributedStringBuilder.attributes[.font] = font.italic
        return attributedStringBuilder
    }
    
    func boldItalic() -> AttributedStringBuilder {
        attributedStringBuilder.attributes[.font] = font.boldItalic
        return attributedStringBuilder
    }
    
    func normal() -> AttributedStringBuilder {
        return attributedStringBuilder
    }
}

extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    
}
