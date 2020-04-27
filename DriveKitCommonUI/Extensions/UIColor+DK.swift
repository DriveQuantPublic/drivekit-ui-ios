//
//  UIColor+DK.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 24/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

@objc public extension UIColor {
    @objc convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    @objc convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
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

