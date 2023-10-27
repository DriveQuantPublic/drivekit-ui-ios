//
//  UICircularRingValueFormatter.swift
//  UICircularProgressRing
//
//  Created by Luis on 2/7/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

import Foundation
import UIKit

// MARK: UICircularRingValueFormatter

/**
 UICircularRingValueFormatter

 Any custom formatter must conform to this protocol.

 */
public protocol UICircularRingValueFormatter {
    /// returns a string for the given object
    func string(for value: Any) -> String?
}

// MARK: UICircularProgressRingFormatter

/**
 UICircularProgressRingFormatter

 The formatter used in UICircularProgressRing class,
 responsible for formatting the value of the ring into a readable string
 */
public struct UICircularProgressRingFormatter: UICircularRingValueFormatter {

    // MARK: Members

    /**
     The name of the value indicator the value label will
     appened to the value
     Example: " GB" -> "100 GB"

     ## Important ##
     Default = "%"

     ## Author
     Luis Padron
     */
    public var valueIndicator: String

    /**
     A toggle for either placing the value indicator right or left to the value
     Example: true -> "GB 100" (instead of 100 GB)

     ## Important ##
     Default = false (place value indicator to the right)

     ## Author
     Elad Hayun
     */
    public var rightToLeft: Bool

    /**
     A toggle for showing or hiding floating points from
     the value in the value label

     ## Important ##
     Default = false (dont show)

     To customize number of decmial places to show, assign a value to decimalPlaces.

     ## Author
     Luis Padron
     */
    public var showFloatingPoint: Bool

    /**
     The amount of decimal places to show in the value label

     ## Important ##
     Default = 2

     Only used when showFloatingPoint = true

     ## Author
     Luis Padron
     */
    public var decimalPlaces: Int

    // MARK: Init

    public init(valueIndicator: String = "%",
                rightToLeft: Bool = false,
                showFloatingPoint: Bool = false,
                decimalPlaces: Int = 2) {
        self.valueIndicator = valueIndicator
        self.rightToLeft = rightToLeft
        self.showFloatingPoint = showFloatingPoint
        self.decimalPlaces = decimalPlaces
    }

    // MARK: API

    /// formats the value of the progress ring using the given properties
    public func string(for value: Any) -> String? {
        guard let value = value as? CGFloat else { return nil }

        if rightToLeft {
            if showFloatingPoint {
                return "\(valueIndicator)" + String(format: "%.\(decimalPlaces)f", value)
            } else {
                return "\(valueIndicator)\(Int(value))"
            }

        } else {
            if showFloatingPoint {
                return String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
            } else {
                return "\(Int(value))\(valueIndicator)"
            }
        }
    }
}
