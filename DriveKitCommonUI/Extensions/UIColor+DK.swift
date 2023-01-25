// swiftlint:disable all
//
//  UIColor+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }
    
    /// Take the tint/hue of the `baseColor` and apply it to `self`
    ///
    /// if the `baseColor` is fully desaturated, it only keeps the luminosity and alpha
    ///  of `self`
    ///
    /// if `baseColor` is fully transparent, it returns `self` unmodified
    /// - Parameter baseColor: the base color from which to get the tint/hue to apply
    /// - Returns: `self` tinted using `baseColor`'s hue
    func tinted(usingHueOf baseColor: UIColor) -> Self {
        var baseHue: CGFloat = 0
        var baseSaturation: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var baseAlpha: CGFloat = 0
        var alpha: CGFloat = 0
        baseColor.getHue(
            &baseHue,
            saturation: &baseSaturation,
            brightness: nil,
            alpha: &baseAlpha
        )
        guard baseAlpha > 0 else {
            return self
        }
        self.getHue(
            nil,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )
        return .init(
            hue: baseHue,
            saturation: baseSaturation > 0 ? saturation : baseSaturation,
            brightness: brightness,
            alpha: alpha
        )
    }
    
    var shouldInvertTextColor: Bool {
        // We should have at least a ratio of 2.8:1 or we need to invert foreground color
        return self.contrastRatio(with: DKUIColors.mainFontColor.color) < 2.8
    }
    
    func contrastRatio(with otherColor: UIColor) -> CGFloat {
        var selfBrightness: CGFloat = 0
        var selfAlpha: CGFloat = 0
        var otherColorBrightness: CGFloat = 0
        var otherColorAlpha: CGFloat = 0
        self.getHue(
            nil,
            saturation: nil,
            brightness: &selfBrightness,
            alpha: &selfAlpha
        )
        otherColor.getHue(
            nil,
            saturation: nil,
            brightness: &otherColorBrightness,
            alpha: &otherColorAlpha
        )
        
        // formula source: https://www.w3.org/TR/WCAG20/#contrast-ratiodef
        return (((selfBrightness * selfAlpha) + 0.05) / ((otherColorBrightness * otherColorAlpha) + 0.05))
    }
    
    static let dkGaugeGray = UIColor(hex: 0xE0E0E0)
    
    static let dkVeryBad = UIColor(hex: 0xff6e57)
    static let dkBad = UIColor(hex: 0xffa057)
    static let dkBadMean = UIColor(hex: 0xffd357)
    static let dkMean = UIColor(hex: 0xf9ff57)
    static let dkGoodMean = UIColor(hex: 0xc6ff57)
    static let dkGood = UIColor(hex: 0x94ff57)
    static let dkExcellent = UIColor(hex: 0x30c8fc)
    static let dkValid = UIColor(red: 20, green: 128, blue: 20)
}
