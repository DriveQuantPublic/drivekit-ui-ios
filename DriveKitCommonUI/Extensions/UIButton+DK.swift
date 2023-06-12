// swiftlint:disable all
//
//  UIButton+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 08/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public extension UIButton {
    
    func configure(title: String, subtitle: String? = nil, style: DKButtonStyle) {
        style.configureButton(button: self)
        style.configureText(title: title, subtitle: subtitle, button: self)
    }
    
    func configure(style: DKButtonStyle) {
        style.configureButton(button: self)
    }
}

public enum DKButtonStyle {
    case full, empty, multilineBordered
    case rounded(
        color: UIColor,
        radius: Double = 8,
        borderWidth: Double = 2,
        style: DKStyle = DKStyles.roundedButton.style,
        textColor: UIColor? = nil
    )

    func configureText(title: String, subtitle: String? = nil, button: UIButton) {
        let attributedText: NSAttributedString
        switch self {
        case .full:
            attributedText = title.dkAttributedString()
                .font(
                    dkFont: .primary,
                    style: .button
                )
                .color(
                    .fontColorOnSecondaryColor
                )
                .uppercased()
                .build()
        case .empty:
            attributedText = title.dkAttributedString()
                .font(
                    dkFont: .primary,
                    style: .button
                )
                .color(
                    .secondaryColor
                )
                .uppercased()
                .build()
        case .multilineBordered:
            let titleAttributedText = title.dkAttributedString()
                .font(
                    dkFont: .primary,
                    style: .headLine1
                )
                .color(
                    .secondaryColor
                )
                .uppercased()
                .build()
            guard let subtitle else {
                attributedText = titleAttributedText
                break
            }
            let subtitleAttributedText = subtitle.dkAttributedString()
                .font(
                    dkFont: .primary,
                    style: .smallText
                )
                .color(.complementaryFontColor)
                .build()
            
            attributedText = "%@\n%@"
                .dkAttributedString()
                .font(dkFont: .primary, style: .smallText)
                .buildWithArgs(
                    titleAttributedText,
                    subtitleAttributedText
                )
        case let .rounded(color, _,  _, style, textColor):
            attributedText = title.dkAttributedString()
                .font(
                    dkFont: .primary,
                    style: style
                )
                .color(
                    textColor ?? color
                )
                .build()
        }
        
        self.configureAttributedText(attributedText, button: button)
    }
    
    func configureAttributedText(_ attributedText: NSAttributedString, button: UIButton) {
        button.setAttributedTitle(attributedText, for: .normal)
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
        case .multilineBordered:
            button.layer.borderColor = DKUIColors.secondaryColor.color.cgColor
            button.layer.borderWidth = 2
            button.contentVerticalAlignment = .top
            button.contentHorizontalAlignment = .leading
            button.contentEdgeInsets = .init(
                top: 12,
                left: 12,
                bottom: 12,
                right: 12
            )
            button.titleLabel?.textAlignment = .left
        case let .rounded(color, radius, borderWidth, _, _):
            button.layer.cornerRadius = radius
            button.layer.masksToBounds = true
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = borderWidth
            let bgColor = color.withAlphaComponent(0.1)
            button.setBackgroundImage(UIImage(color: bgColor), for: .normal)
            button.setBackgroundImage(UIImage(color: bgColor), for: .disabled)
        }
    }
}
