//
//  NSAttributedString+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 21/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    public func replaceFont(with font: UIFont) {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: length)) { (value, range, stop) in
            if let f = value as? UIFont {

                let familyName = font.familyName
                let fontDescriptor = f.fontDescriptor
                let ufd = fontDescriptor.withFamily(familyName)

                if let ufd2 = ufd.withSymbolicTraits(fontDescriptor.symbolicTraits) {
                    let newFont = UIFont(descriptor: ufd2, size: font.pointSize)
                    removeAttribute(.font, range: range)
                    addAttribute(.font, value: newFont, range: range)
                }
            }
        }
        endEditing()
    }
}
