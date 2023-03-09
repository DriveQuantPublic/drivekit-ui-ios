// swiftlint:disable no_magic_numbers
//
//  MySynthesisGaugeConstants.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 08/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

enum MySynthesisGaugeConstants {
    static let defaultColor = UIColor(hex: 0x036A82)
    
    static func circleIcon(diameter: CGFloat = 12, insideColor: UIColor = .white) -> UIImage? {
        return UIImage.circleIcon(diameter: diameter, borderColor: self.defaultColor, insideColor: insideColor)
    }
    
    static func filledCircleIcon(diameter: CGFloat = 12) -> UIImage? {
        circleIcon(diameter: diameter, insideColor: self.defaultColor)
    }

    static func triangleIcon(width: CGFloat = 20) -> UIImage? {
        let scale: CGFloat = 0
        let size = CGSize(width: width, height: width)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: width))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        defaultColor.setFill()
        bezierPath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
