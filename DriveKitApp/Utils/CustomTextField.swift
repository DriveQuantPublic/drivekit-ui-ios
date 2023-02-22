// swiftlint:disable all
//
//  CustomTextField.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class CustomTextField: HoshiTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeAsBranded()
    }
}

extension HoshiTextField {
    func customizeAsBranded() {
        borderActiveColor = DKUIColors.secondaryColor.color
        borderInactiveColor = DKUIColors.complementaryFontColor.color
        placeholderColor = DKUIColors.complementaryFontColor.color
        textColor = DKUIColors.mainFontColor.color
        font = DKUIFonts.primary.fonts(size: 16.0)
        placeholderFontScale = 1
        borderStyle = .none
        backgroundColor = UIColor.clear
        placeholderLabel.font = DKUIFonts.primary.fonts(size: 16.0)
    }
}
