//
//  LineGraphView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import ChartsForDK
import DriveKitCommonUI

class LineGraphView: GraphViewBase {
    private let chartView: LineChartView
    private let defaultIcon = GraphConstants.circleIcon()
    private var selectedEntry: ChartDataEntry? = nil

    override init(viewModel: GraphViewModel) {
        self.chartView = LineChartView()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getChartView() -> BarLineChartViewBase? {
        return self.chartView
    }

    override func setupData() {
        var lineChartEntry  = [ChartDataEntry]()

        for (index, point) in self.viewModel.points.enumerated() {
            if let point {
                let value = ChartDataEntry(x: point.x, y: point.y, data: point.data)
                if index == self.viewModel.selectedIndex {
                    select(entry: value)
                } else {
                    value.icon = self.defaultIcon
                }
                lineChartEntry.append(value)
            }
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: nil)
        line1.colors = [UIColor(hex: 0x083B54)]
        line1.drawVerticalHighlightIndicatorEnabled = false
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.highlightEnabled = true
        line1.drawValuesEnabled = false
        line1.drawCirclesEnabled = false
        line1.lineWidth = 2

        let data = LineChartData()
        data.addDataSet(line1)
        data.highlightEnabled = true

        self.chartView.data = data
        self.chartView.highlightPerTapEnabled = true
        self.chartView.pinchZoomEnabled = false
        self.chartView.scaleXEnabled = false
        self.chartView.scaleYEnabled = false
        self.chartView.dragEnabled = false
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.rightAxis.enabled = false
        self.chartView.legend.enabled = false

        if let xAxisConfig = self.viewModel.xAxisConfig {
            self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: xAxisConfig)
            self.chartView.xAxis.setLabelCount(xAxisConfig.labels.count, force: true)
            self.chartView.xAxis.decimals = 0
            self.chartView.xAxis.axisMinimum = xAxisConfig.min
            self.chartView.xAxis.axisMaximum = xAxisConfig.max
            self.chartView.xAxis.drawAxisLineEnabled = false
            self.chartView.xAxis.drawGridLinesEnabled = false
        }
        self.chartView.xAxis.labelPosition = .bottom

        if let yAxisConfig = self.viewModel.yAxisConfig {
            self.chartView.leftAxis.valueFormatter = GraphAxisFormatter(config: yAxisConfig)
            self.chartView.leftAxis.setLabelCount(yAxisConfig.labels.count, force: true)
            self.chartView.leftAxis.decimals = 0
            self.chartView.leftAxis.axisMinimum = yAxisConfig.min
            self.chartView.leftAxis.axisMaximum = yAxisConfig.max
            self.chartView.leftAxis.gridLineDashLengths = [4, 2]
            self.chartView.leftAxis.drawAxisLineEnabled = false
        }
        self.chartView.leftAxis.labelPosition = .outsideChart

        self.chartView.delegate = self
    }

    private func select(entry: ChartDataEntry) {
        self.selectedEntry = entry
        entry.icon = GraphConstants.selectedCircleIcon()
    }
}

extension LineGraphView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if entry != self.selectedEntry {
            self.selectedEntry?.icon = self.defaultIcon
            select(entry: entry)
            self.delegate?.graphDidSelectPoint((x: entry.x, y: entry.y, data: entry.data))
        }
    }
}