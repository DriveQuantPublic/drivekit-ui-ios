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
        for i in 0..<items.count {
            let startX = rect.origin.x + drawnPercent * (rect.width - 2 * margin) + margin
            let itemRect = CGRect(x: startX, y: rect.origin.y + margin, width: (rect.width - 2 * margin) * items[i].percent, height: rect.height - 2 * margin)
            self.drawPartView(itemRect, color: items[i].color.cgColor, margin: margin)
            drawnPercent += items[i].percent
        }

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        maskLayer.path = path
        self.layer.mask = maskLayer
    }

    private func drawPartView(_ rect: CGRect, color: CGColor, margin: Double = 0) {
        let bezierPath = UIBezierPath()
        let startPoint = rect.origin
        let endPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        bezierPath.move(to: startPoint)
        bezierPath.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
        bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        bezierPath.addLine(to: CGPoint(x: startPoint.x, y: endPoint.y))
        bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))
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
