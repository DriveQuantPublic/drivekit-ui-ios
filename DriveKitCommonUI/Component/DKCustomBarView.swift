// swiftlint:disable no_magic_numbers
//
//  DKCustomBarView.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

open class DKCustomBarView: UIView {

    public func draw(items: [DKCustomBarViewItem], rect: CGRect, radius: Double = 8, margin: Double = 0) {
        var drawnPercent: Double = 0
        for i in 0..<items.count {
            let roundedStart: Bool = (i == 0)
            let roundedEnd: Bool = (i == items.count - 1)
            let startX = rect.origin.x + drawnPercent * (rect.width - 2 * margin) + margin
            let itemRect = CGRect(x: startX, y: rect.origin.y + margin, width: (rect.width - 2 * margin) * items[i].percent, height: rect.height - 2 * margin)
            self.drawPartView(itemRect, color: items[i].color.cgColor, roundedStart: roundedStart, roundedEnd: roundedEnd, radius: radius, margin: margin)
            drawnPercent += items[i].percent
        }

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        maskLayer.path = path
        self.layer.mask = maskLayer
    }

    private func drawPartView(_ rect: CGRect, color: CGColor, roundedStart: Bool = false, roundedEnd: Bool = false, radius: Double = 8, margin: Double = 0) {
        let bezierPath = UIBezierPath()
        let startPoint = rect.origin
        let endPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        if roundedStart {
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + radius, y: startPoint.y + radius), radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
        } else {
            bezierPath.move(to: startPoint)
        }
        if roundedEnd {
            bezierPath.addLine(to: CGPoint(x: endPoint.x - radius, y: startPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - radius, y: startPoint.y + radius), radius: radius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y - radius))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - radius, y: endPoint.y - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
        if roundedStart {
            bezierPath.addLine(to: CGPoint(x: startPoint.x + radius, y: endPoint.y))
            bezierPath.addLine(to: CGPoint(x: startPoint.x + radius, y: endPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + radius, y: endPoint.y - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - radius))
        } else {
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: endPoint.y))
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))
        }
        UIGraphicsGetCurrentContext()?.setFillColor(color)
        bezierPath.fill()
    }
}

public class DKCustomBarViewItem {
    let percent: CGFloat
    let color: UIColor

    public init(percent: CGFloat, color: UIColor) {
        self.percent = percent
        self.color = color
    }
}
