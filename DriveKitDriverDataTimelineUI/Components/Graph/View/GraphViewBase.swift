// swiftlint:disable no_magic_numbers
//
//  GraphViewBase.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DGCharts
import DriveKitCommonUI

class GraphViewBase: UIView {
    static let axisLabelColor: UIColor = UIColor(hex: 0x333333)
    weak var delegate: GraphViewDelegate?
    private(set) var viewModel: GraphViewModel

    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        let chartView = getChartView()
        self.embedSubview(chartView)
        self.viewModel.graphViewModelDidUpdate = { [weak self] in
            self?.setupData()
        }
        setupData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getChartView() -> BarLineChartViewBase {
        preconditionFailure("Must be overridden by subclass")
    }

    func setupData() {
        preconditionFailure("Must be overridden by subclass")
    }
}

class GraphAxisFormatter: IndexAxisValueFormatter {
    private let config: GraphAxisConfig

    init(config: GraphAxisConfig) {
        self.config = config
        super.init()
    }

    override func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        if let labels = self.config.labels.titles {
            let index = Int(value - self.config.min)
            if index >= 0 && index < labels.count {
                return labels[index]
            }
        }
        return String(value.formatDouble(places: 1))
    }
}

class DKXAxisRenderer: XAxisRenderer {
    private let config: GraphAxisConfig
    var selectedIndex: Int?

    static func from(_ chartView: BarLineChartViewBase, config: GraphAxisConfig) -> DKXAxisRenderer {
        let renderer = DKXAxisRenderer(config: config, viewPortHandler: chartView.viewPortHandler, xAxis: chartView.xAxis, transformer: chartView.getTransformer(forAxis: .left))
        return renderer
    }

    init(config: GraphAxisConfig, viewPortHandler: ViewPortHandler, xAxis: XAxis, transformer: Transformer?) {
        self.config = config
        super.init(viewPortHandler: viewPortHandler, axis: xAxis, transformer: transformer)
    }

    override func drawLabel(
        context: CGContext,
        formattedLabel: String,
        x: CGFloat,
        y: CGFloat,
        attributes: [NSAttributedString.Key: Any],
        constrainedTo constrainedToSize: CGSize, 
        anchor: CGPoint,
        angleRadians: CGFloat) {
        var textAttributes = attributes
        if let index = self.config.labels.titles?.firstIndex(of: formattedLabel), index == self.selectedIndex {
            let textSize = formattedLabel.boundingRect(with: constrainedToSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
            var rect = CGRect(origin: CGPoint(), size: textSize)
            let point = CGPoint(x: x, y: y)
            UIGraphicsPushContext(context)
            if anchor.x != 0.0 || anchor.y != 0.0 {
                rect.origin.x = -textSize.width * anchor.x
                rect.origin.y = -textSize.height * anchor.y
            }
            rect.origin.x += point.x
            rect.origin.y += point.y
            let selectedBackgroundColor = GraphConstants.defaultSelectedColor.withAlphaComponent(0.5)
            selectedBackgroundColor.setFill()
            let xInset: CGFloat = -4
            UIBezierPath(roundedRect: rect.insetBy(dx: xInset, dy: 0), cornerRadius: rect.height / 2).fill()
            UIGraphicsPopContext()
            if selectedBackgroundColor.shouldInvertTextColor {
                textAttributes[.foregroundColor] = UIColor.white
            }
        }
        super.drawLabel(
            context: context,
            formattedLabel: formattedLabel,
            x: x,
            y: y,
            attributes: textAttributes,
            constrainedTo: constrainedToSize,
            anchor: anchor,
            angleRadians: angleRadians
        )
    }
}
