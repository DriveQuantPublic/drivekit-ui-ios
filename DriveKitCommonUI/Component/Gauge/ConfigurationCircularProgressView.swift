// swiftlint:disable no_magic_numbers
//
//  ConfigurationCircularProgressView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 10/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import UICircularProgressRingForDK

public enum CircularProgressViewSize {
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
            return 12
        case .medium:
            return 16
        case .large:
            return 28
        }
    }
}

public class ConfigurationCircularProgressView {

    let style: UICircularRingStyle
    let maxValue: Double
    let value: Double
    let ringWidth: Int
    let fontColor: UIColor
    let fontSize: Int
    let valueIndicator: String
    let showFloatingPoint: Bool
    let decimalPlaces: Int
    let steps: [Double]
    let image: UIImage?
    let startAngle: Float
    let endAngle: Float
    let ringColor: UIColor
    let valueFormatter: UICircularRingValueFormatter

    public init(style: UICircularRingStyle?,
                maxValue: Double,
                value: Double,
                steps: [Double],
                image: UIImage? = nil,
                ringWidth: Int?,
                startAngle: Float = 0,
                endAngle: Float = 360,
                fontColor: UIColor?,
                fontSize: Int?,
                indicator: String?,
                floatingPoint: Bool = true,
                decimalPlaces: Int = 1) {
        self.style = style ?? .ontop
        self.maxValue = maxValue
        self.value = value
        self.steps = steps
        self.image = image
        self.ringWidth = ringWidth ?? 4
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.fontColor = fontColor ?? DKUIColors.mainFontColor.color
        self.fontSize = fontSize ?? 11
        self.valueIndicator = indicator ?? ""
        self.decimalPlaces = decimalPlaces
        if self.value == self.maxValue {
            self.showFloatingPoint = false
        } else {
            self.showFloatingPoint = floatingPoint
        }
        self.ringColor = ConfigurationCircularProgressView.getScoreColor(value: self.value, steps: self.steps)
        self.valueFormatter = CircularRingValueFormatter(valueIndicator: self.valueIndicator, decimalPlaces: self.decimalPlaces, rightToLeft: false)
    }

    public init(scoreType: DKScoreType, value: Double, size: CircularProgressViewSize) {
        self.style = .ontop
        self.maxValue = 10
        self.value = value.round(places: 1)
        self.steps = scoreType.getSteps()
        self.image = scoreType.gaugeImage()
        self.ringWidth = size.ringWidth
        self.startAngle = 45
        self.endAngle = 270
        self.fontColor = DKUIColors.mainFontColor.color
        self.fontSize = size.fontSize
        self.valueIndicator = ""
        self.decimalPlaces = 1
        self.showFloatingPoint = self.value.truncatingRemainder(dividingBy: 1) != 0
        self.ringColor = ConfigurationCircularProgressView.getScoreColor(value: self.value, steps: self.steps)
        self.valueFormatter = CircularRingValueFormatter(valueIndicator: self.valueIndicator, decimalPlaces: self.decimalPlaces, rightToLeft: false)
    }

    public init(gaugeConfiguration: DKGaugeConfiguration, size: CircularProgressViewSize) {
        self.style = .ontop
        self.maxValue = 10
        self.value = (gaugeConfiguration.getProgress() * self.maxValue).round(places: 1)
        self.steps = []
        self.ringWidth = size.ringWidth
        self.fontColor = DKUIColors.mainFontColor.color
        self.fontSize = size.fontSize
        self.valueIndicator = gaugeConfiguration.getTitle()
        self.decimalPlaces = 1
        self.showFloatingPoint = self.value.truncatingRemainder(dividingBy: 1) != 0
        self.ringColor = gaugeConfiguration.getColor()
        let gaugeType = gaugeConfiguration.getGaugeType()
        self.startAngle = gaugeType.getStartAngle()
        self.endAngle = gaugeType.getEndAngle()
        switch gaugeConfiguration.getGaugeType() {
            case .closed, .open:
                self.image = nil
            case let .openWithIcon(icon):
                self.image = icon
        }
        self.valueFormatter = ValueIndicator(gaugeConfiguration: gaugeConfiguration)
    }

    public static func getScoreColor(value: Double, steps: [Double]) -> UIColor {
        guard steps.count >= 7 else {
            return UIColor.black
        }
        if value <= steps[1] {
            return UIColor.dkVeryBad
        } else if value <= steps[2] {
            return UIColor.dkBad
        } else if value <= steps[3] {
            return UIColor.dkBadMean
        } else if value <= steps[4] {
            return UIColor.dkMean
        } else if value <= steps[5] {
            return UIColor.dkGoodMean
        } else if value <= steps[6] {
            return UIColor.dkGood
        }
        return UIColor.dkExcellent
    }
    
}

private struct CircularRingValueFormatter: UICircularRingValueFormatter {
    fileprivate let valueIndicator: String
    fileprivate let decimalPlaces: Int
    fileprivate let rightToLeft: Bool

    func string(for value: Any) -> String? {
        guard let value = value as? CGFloat else { return nil }
        let doubleValue = Double(value)
        if self.rightToLeft {
            return self.valueIndicator + doubleValue.formatDouble(places: self.decimalPlaces)
        } else {
            return doubleValue.formatDouble(places: self.decimalPlaces) + self.valueIndicator
        }
    }
}

private struct ValueIndicator: UICircularRingValueFormatter {
    fileprivate let gaugeConfiguration: DKGaugeConfiguration

    func string(for value: Any) -> String? {
        return gaugeConfiguration.getTitle()
    }
}
