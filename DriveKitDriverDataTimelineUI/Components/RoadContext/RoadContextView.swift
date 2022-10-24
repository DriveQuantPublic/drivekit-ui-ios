//
//  RoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule

class RoadContextView: UIView {
    static private let radius: Double = 10
    static private let margin: Double = 5
    private var viewModel: RoadContextViewModel?

    override func draw(_ rect: CGRect) {
        guard let itemsToDraw = viewModel?.itemsToDraw, itemsToDraw.count > 0 else {
            return
        }
        var drawnPercent: Double = 0
        for i in 0..<itemsToDraw.count {
            let roundedStart: Bool = (i == 0)
            let roundedEnd: Bool = (i == itemsToDraw.count - 1)
            let startX = drawnPercent*(rect.width - 2*RoadContextView.margin) + RoadContextView.margin
            let itemRect = CGRect(x: startX, y: RoadContextView.margin, width: (rect.width - 2*RoadContextView.margin)*itemsToDraw[i].percent, height: rect.height - 2*RoadContextView.margin)
            self.drawPartView(itemRect, color: RoadContextViewModel.getContextColor(itemsToDraw[i].context).cgColor, roundedStart: roundedStart, roundedEnd: roundedEnd)
            drawnPercent = drawnPercent + itemsToDraw[i].percent
        }
    }

    private func drawPartView(_ rect: CGRect, color: CGColor, roundedStart: Bool = false, roundedEnd: Bool = false) {
        let bezierPath = UIBezierPath()
        let startPoint = rect.origin
        let endPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        if roundedStart {
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + RoadContextView.radius, y: startPoint.y + RoadContextView.radius), radius: RoadContextView.radius, startAngle: .pi, endAngle: .pi*3/2, clockwise: true)
        } else {
            bezierPath.move(to: startPoint)
        }
        if roundedEnd {
            bezierPath.addLine(to: CGPoint(x: endPoint.x - RoadContextView.radius, y: startPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - RoadContextView.radius, y: startPoint.y + RoadContextView.radius), radius: RoadContextView.radius, startAngle: .pi*3/2, endAngle: .pi*2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y - RoadContextView.radius))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - RoadContextView.radius, y: endPoint.y - RoadContextView.radius), radius: RoadContextView.radius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
        if roundedStart {
            bezierPath.addLine(to: CGPoint(x: startPoint.x + RoadContextView.radius, y: endPoint.y))
            bezierPath.addLine(to: CGPoint(x: startPoint.x + RoadContextView.radius, y: endPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + RoadContextView.radius, y: endPoint.y - RoadContextView.radius), radius: RoadContextView.radius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - RoadContextView.radius))
        } else {
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: endPoint.y))
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))
        }
        UIGraphicsGetCurrentContext()?.setFillColor(color)
        bezierPath.fill()
    }

    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}
