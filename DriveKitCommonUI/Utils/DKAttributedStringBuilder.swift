//
//  AttributedStringBuilder.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class DKAttributedStringBuilder {
    
    private let text : String
    var attributes : [NSAttributedString.Key: Any] = [:]
    
    init(text: String) {
        self.text = text
    }
    
    public func font(dkFont: DKUIFonts, style: DKStyles) -> DKAttributedStringBuilder {
        return font(dkFont: dkFont, style: style.style)
    }
    
    public func font(dkFont: DKUIFonts, style: DKStyle) -> DKAttributedStringBuilder {
        attributes[.font] = style.applyTo(font: dkFont)
        return self
    }
    
    public func color(_ color: DKUIColors) -> DKAttributedStringBuilder{
        attributes[.foregroundColor] = color.color
        return self
    }
    
    public func build() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}

public extension String {
    func dkAttributedString() -> DKAttributedStringBuilder {
        return DKAttributedStringBuilder(text: self)
    }
}
