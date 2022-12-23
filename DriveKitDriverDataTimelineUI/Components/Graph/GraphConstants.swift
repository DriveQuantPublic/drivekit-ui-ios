//
//  GraphConstants.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by Amine Gahbiche on 07/11/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

enum GraphConstants {
    static let defaultLineColor = UIColor(hex: 0x0B4D6E)
    static let defaultSelectedColor = DKUIColors.secondaryColor.color
    
    static let defaultNumberOfIntervalInYAxis = 10
    static let defaultMaxValueInYAxis = 10.0
    static let notEnoughDataInGraphThreshold = 10.0
    static let maxValueInYAxisWhenNotEnoughDataInGraph = 10.0

    static func circleIcon(size: CGSize = CGSize(width: 14, height: 14), insideColor: UIColor = .white) -> UIImage? {
        let scale: CGFloat = 0
        let lineWidth: CGFloat = 4
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let path = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2), radius: size.width/2 - lineWidth/2, startAngle: 0, endAngle: 2*Double.pi, clockwise: true)
        path.lineWidth = lineWidth
        GraphConstants.defaultLineColor.setStroke()
        insideColor.setFill()
        path.stroke()
        path.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    static func invisibleIcon() -> UIImage? {
        let scale: CGFloat = 0
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        UIColor.clear.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    static func selectedCircleIcon() -> UIImage? {
        GraphConstants.circleIcon(insideColor: GraphConstants.defaultSelectedColor)
    }
}
