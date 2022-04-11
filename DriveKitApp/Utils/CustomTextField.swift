//
//  CustomTextField.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import TextFieldEffects
import DriveKitCommonUI
import UIKit

class CustomTextField: HoshiTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeAsBranded()
    }
}

extension HoshiTextField {
    func customizeAsBranded() {
        let mainColor = UIColor(hex:0x616161)
        borderActiveColor = DKUIColors.secondaryColor.color
        borderInactiveColor = mainColor
        placeholderColor = mainColor
        textColor = mainColor
        font = DKUIFonts.primary.fonts(size: 16.0)
        placeholderFontScale = 1
        borderStyle = .none
        backgroundColor = UIColor.clear
        placeholderLabel.font = DKUIFonts.primary.fonts(size: 16.0)
    }
}
