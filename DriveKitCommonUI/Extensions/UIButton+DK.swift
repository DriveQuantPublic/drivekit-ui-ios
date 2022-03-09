//
//  UIButton+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public extension UIButton {
    
    func configure(text: String, style: DKButtonStyle) {
        style.configureButton(button: self)
        style.configureText(text: text, button: self)
    }

    func configure(style: DKButtonStyle) {
        style.configureButton(button: self)
    }
}

public enum DKButtonStyle {
    case full, empty, rounded(color: UIColor)

    func configureText(text: String, button: UIButton) {
        switch self {
        case .full:
            button.setAttributedTitle(text.dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        case .empty:
            button.setAttributedTitle(text.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
        case let .rounded(color):
            button.setAttributedTitle(text.dkAttributedString().font(dkFont: .primary, style: .button).color(color).uppercased().build(), for: .normal)
        }
    }

    func configureButton(button: UIButton) {
        switch self {
        case .full:
            button.layer.cornerRadius = 2
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 4
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.masksToBounds = false
            button.setBackgroundImage(UIImage(color: DKUIColors.secondaryColor.color), for: .normal)
            button.setBackgroundImage(UIImage(color: DKUIColors.secondaryColor.color.withAlphaComponent(0.5)), for: .disabled)
        case .empty:
            break
        case let .rounded(color):
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = 2
            let bgColor = color.withAlphaComponent(0.1)
            button.setBackgroundImage(UIImage(color: bgColor), for: .normal)
            button.setBackgroundImage(UIImage(color: bgColor), for: .disabled)
        }
    }
}
