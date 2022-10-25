//
//  RoadContextView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class RoadContextView: UIView {
    @IBOutlet private weak var roadContextBarView: RoadContextBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emptyLabel: UILabel!
    private var viewModel: RoadContextViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        self.titleLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        if let viewModel = viewModel {
            self.titleLabel.text = viewModel.getTitle()
            self.roadContextBarView.configure(viewModel: viewModel)
        }
    }
    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.setupView()
    }
}

class RoadContextBarView: UIView {
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
            let startX = drawnPercent*(rect.width - 2*RoadContextBarView.margin) + RoadContextBarView.margin
            let itemRect = CGRect(x: startX, y: RoadContextBarView.margin, width: (rect.width - 2*RoadContextBarView.margin)*itemsToDraw[i].percent, height: rect.height - 2*RoadContextBarView.margin)
            self.drawPartView(itemRect, color: RoadContextViewModel.getContextColor(itemsToDraw[i].context).cgColor, roundedStart: roundedStart, roundedEnd: roundedEnd)
            drawnPercent = drawnPercent + itemsToDraw[i].percent
        }
    }

    private func drawPartView(_ rect: CGRect, color: CGColor, roundedStart: Bool = false, roundedEnd: Bool = false) {
        let bezierPath = UIBezierPath()
        let startPoint = rect.origin
        let endPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        if roundedStart {
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + RoadContextBarView.radius, y: startPoint.y + RoadContextBarView.radius), radius: RoadContextBarView.radius, startAngle: .pi, endAngle: .pi*3/2, clockwise: true)
        } else {
            bezierPath.move(to: startPoint)
        }
        if roundedEnd {
            bezierPath.addLine(to: CGPoint(x: endPoint.x - RoadContextBarView.radius, y: startPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - RoadContextBarView.radius, y: startPoint.y + RoadContextBarView.radius), radius: RoadContextBarView.radius, startAngle: .pi*3/2, endAngle: .pi*2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y - RoadContextBarView.radius))
            bezierPath.addArc(withCenter: CGPoint(x: endPoint.x - RoadContextBarView.radius, y: endPoint.y - RoadContextBarView.radius), radius: RoadContextBarView.radius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
            bezierPath.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
        if roundedStart {
            bezierPath.addLine(to: CGPoint(x: startPoint.x + RoadContextBarView.radius, y: endPoint.y))
            bezierPath.addLine(to: CGPoint(x: startPoint.x + RoadContextBarView.radius, y: endPoint.y))
            bezierPath.addArc(withCenter: CGPoint(x: startPoint.x + RoadContextBarView.radius, y: endPoint.y - RoadContextBarView.radius), radius: RoadContextBarView.radius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - RoadContextBarView.radius))
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
