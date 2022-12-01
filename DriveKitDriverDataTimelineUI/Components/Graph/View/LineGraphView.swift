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
        var entries  = [ChartDataEntry]()
        for (index, point) in self.viewModel.points.enumerated() {
            if let point {
                let value = ChartDataEntry(x: point.x, y: point.y, data: point.data)
                if index == self.viewModel.selectedIndex {
                    select(entry: value)
                } else {
                    value.icon = self.defaultIcon
                }
                entries.append(value)
            }
        }

        let line = LineChartDataSet(entries: entries, label: nil)
        line.colors = [UIColor(hex: 0x083B54)]
        line.drawVerticalHighlightIndicatorEnabled = false
        line.drawHorizontalHighlightIndicatorEnabled = false
        line.highlightEnabled = true
        line.drawValuesEnabled = false
        line.drawCirclesEnabled = false
        line.lineWidth = 2

        let data = LineChartData()
        data.addDataSet(line)
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
        self.chartView.extraLeftOffset = 4
        self.chartView.extraRightOffset = 20

        self.chartView.xAxis.decimals = 0
        self.chartView.xAxis.drawAxisLineEnabled = false
        self.chartView.xAxis.drawGridLinesEnabled = false
        self.chartView.xAxis.labelPosition = .bottom
        if let xAxisConfig = self.viewModel.xAxisConfig {
            self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: xAxisConfig)
            if let labels = xAxisConfig.labels {
                self.chartView.xAxis.setLabelCount(labels.count, force: true)
            }
            if let min = xAxisConfig.min {
                self.chartView.xAxis.axisMinimum = min
            }
            if let max = xAxisConfig.max {
                self.chartView.xAxis.axisMaximum = max
            }
        }

        self.chartView.leftAxis.decimals = 0
        self.chartView.leftAxis.gridLineDashLengths = [4, 2]
        self.chartView.leftAxis.drawAxisLineEnabled = false
        self.chartView.leftAxis.labelPosition = .outsideChart
        self.chartView.leftAxis.labelXOffset = -4
        if let yAxisConfig = self.viewModel.yAxisConfig {
            self.chartView.leftAxis.valueFormatter = GraphAxisFormatter(config: yAxisConfig)
            if let labels = yAxisConfig.labels {
                self.chartView.leftAxis.setLabelCount(labels.count, force: true)
            }
            if let min = yAxisConfig.min {
                self.chartView.leftAxis.axisMinimum = min
            }
            if let max = yAxisConfig.max {
                self.chartView.leftAxis.axisMaximum = max
            }
        }

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
