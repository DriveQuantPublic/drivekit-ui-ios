//
//  ConfigurationCircularProgressView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 10/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import UICircularProgressRing
import DriveKitDriverData

enum CircularProgressViewSize {
    case small, medium, large
    
    var ringWidth: Int {
        switch self {
        case .small:
            return 4
        case .medium:
            return 7
        case .large:
            return 10
        }
    }
    
    var fontSize: Int {
        switch self {
        case .small:
            return 11
        case .medium:
            return 16
        case .large:
            return 24
        }
    }
}

class ConfigurationCircularProgressView {
    
    var style: UICircularRingStyle
    var maxValue: Double
    var value: Double
    var ringWidth: Int
    var fontColor: UIColor
    var fontSize: Int
    var valueIndicator: String
    var showFloatingPoint: Bool
    var decimalPlaces: Int
    var steps: [Double]
    var image: UIImage?
    
    init(style: UICircularRingStyle?, maxValue: Double, value: Double, steps: [Double], image: UIImage? = nil, ringWidth: Int?, fontColor: UIColor?, fontSize: Int?, indicator: String?, floatingPoint: Bool = true, decimalPlaces: Int = 1) {
        
        self.style = style ?? .ontop
        self.maxValue = maxValue
        self.value = value
        self.steps = steps
        self.image = image
        self.ringWidth = ringWidth ?? 4
        self.fontColor = fontColor ?? UIColor.dkDarkGrayText
        self.fontSize = fontSize ?? 11
        self.valueIndicator = indicator ?? ""
        self.showFloatingPoint = floatingPoint
        self.decimalPlaces = decimalPlaces
        if self.value == self.maxValue {
            self.showFloatingPoint = false
        }
    }
    
    init(scoreType: ScoreType, trip: Trip, size: CircularProgressViewSize) {
        self.style = .ontop
        self.maxValue = 10
        self.value = scoreType.rawValue(trip: trip)
        self.steps = scoreType.getSteps()
        self.image = UIImage(named: scoreType.imageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        self.ringWidth = size.ringWidth
        self.fontColor = .dkDarkGrayText
        self.fontSize = size.fontSize
        self.valueIndicator = ""
        self.showFloatingPoint = true
        self.decimalPlaces = 1
        if self.value == self.maxValue {
            self.showFloatingPoint = false
        }
    }
    
}
