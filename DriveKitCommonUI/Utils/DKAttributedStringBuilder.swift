//
//  AttributedStringBuilder.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 27/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class DKAttributedStringBuilder {
    
    private var text: String
    var attributes: [NSAttributedString.Key: Any] = [:]
    
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
    
    public func color(_ color: DKUIColors) -> DKAttributedStringBuilder {
        attributes[.foregroundColor] = color.color
        return self
    }
    
    public func uppercased() -> DKAttributedStringBuilder {
        self.text = text.uppercased()
        return self
    }
    
    public func color(_ color: UIColor) -> DKAttributedStringBuilder {
        attributes[.foregroundColor] = color
        return self
    }
    
    public func build() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    public func buildWithArgs(_ args: NSMutableAttributedString...) -> NSMutableAttributedString {
        self.buildWithArgs(args)
    }
    
    public func buildWithArgs(_ args: [NSMutableAttributedString]) -> NSMutableAttributedString {
        let stringsPart = self.text.components(separatedBy: "%@")
        let attributedString = NSMutableAttributedString(string: stringsPart[0], attributes: attributes)
        for i in 0...stringsPart.count {
            if args.count > i {
                attributedString.append(args[i])
            }
            if stringsPart.count > i + 1 {
                attributedString.append(NSMutableAttributedString(string: stringsPart[i + 1], attributes: attributes))
            }
        }
        return attributedString
    }
    
    public func primaryFontNormalTextMainFontColor() -> NSMutableAttributedString {
        return self.font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
}

public extension String {
    func dkAttributedString() -> DKAttributedStringBuilder {
        return DKAttributedStringBuilder(text: self)
    }
}
