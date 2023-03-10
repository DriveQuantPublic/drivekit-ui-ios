// swiftlint:disable all
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
    static let defaultLineColor = UIColor(hex: 0x083B54)
    static let defaultSelectedColor = DKUIColors.secondaryColor.color
    
    static let defaultNumberOfIntervalInYAxis = 10
    static let defaultMaxValueInYAxis = 10.0
    static let notEnoughDataInGraphThreshold = 10.0
    static let maxValueInYAxisWhenNotEnoughDataInGraph = 10.0

    static func circleIcon(diameter: Double = 14, insideColor: UIColor = .white) -> UIImage? {
        return UIImage.circleIcon(diameter: diameter, borderColor: GraphConstants.defaultLineColor, insideColor: insideColor)
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
