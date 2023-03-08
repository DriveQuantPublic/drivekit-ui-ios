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
        let scale: CGFloat = 0
        let lineWidth: CGFloat = 4
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let path = UIBezierPath(
            arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2 - lineWidth / 2,
            startAngle: 0,
            endAngle: 2 * Double.pi,
            clockwise: true)
        path.lineWidth = lineWidth
        defaultColor.setStroke()
        insideColor.setFill()
        path.stroke()
        path.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
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
