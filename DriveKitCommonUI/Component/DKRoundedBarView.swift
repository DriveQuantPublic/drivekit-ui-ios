// swiftlint:disable no_magic_numbers
//
//  DKRoundedBarView.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

open class DKRoundedBarView: UIView {

    public func draw(items: [DKRoundedBarViewItem], rect: CGRect, cornerRadius: Double = 8, margin: Double = 0) {
        var drawnPercent: Double = 0
        for item in items {
            let startX = rect.origin.x + drawnPercent * (rect.width - 2 * margin) + margin
            let itemRect = CGRect(x: startX, y: rect.origin.y + margin, width: (rect.width - 2 * margin) * item.percent, height: rect.height - 2 * margin)
            self.drawPartView(itemRect, color: item.color.cgColor)
            drawnPercent += item.percent
        }

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        maskLayer.path = path
        self.layer.mask = maskLayer
    }

    private func drawPartView(_ rect: CGRect, color: CGColor) {
        let bezierPath = UIBezierPath(rect: rect)
        UIGraphicsGetCurrentContext()?.setFillColor(color)
        bezierPath.fill()
    }
}

public class DKRoundedBarViewItem {
    let percent: CGFloat
    let color: UIColor

    public init(percent: CGFloat, color: UIColor) {
        self.percent = percent
        self.color = color
    }
}
