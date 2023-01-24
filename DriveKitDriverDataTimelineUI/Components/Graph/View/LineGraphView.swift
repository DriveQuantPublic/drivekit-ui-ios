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
    private let invisibleIcon = GraphConstants.invisibleIcon()
    private var selectedEntry: ChartDataEntry?

    override init(viewModel: GraphViewModel) {
        self.chartView = LineChartView()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getChartView() -> BarLineChartViewBase {
        return self.chartView
    }

    override func setupData() {
        if let xAxisConfig = self.viewModel.xAxisConfig {
            self.chartView.xAxisRenderer = DKXAxisRenderer.from(self.chartView, config: xAxisConfig)
        }
        var entries = [ChartDataEntry]()
        for (index, point) in self.viewModel.points.enumerated() {
            if let point {
                let value = ChartDataEntry(x: point.x, y: point.y, data: point.data)
                let interpolatedPoint = point.data?.interpolatedPoint ?? true
                if index == self.viewModel.selectedIndex {
                    select(entry: value, interpolatedPoint: interpolatedPoint)
                } else if interpolatedPoint {
                    value.icon = self.invisibleIcon
                } else {
                    value.icon = self.defaultIcon
                }
                entries.append(value)
            }
        }

        let line = LineChartDataSet(entries: entries, label: nil)
        line.colors = [GraphConstants.defaultLineColor]
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
        self.chartView.xAxis.labelTextColor = GraphViewBase.axisLabelColor
        self.chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        if let xAxisConfig = self.viewModel.xAxisConfig {
            self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: xAxisConfig)
            self.chartView.xAxis.setLabelCount(xAxisConfig.labels.count, force: true)
            self.chartView.xAxis.axisMinimum = xAxisConfig.min
            self.chartView.xAxis.axisMaximum = xAxisConfig.max
        }

        self.chartView.leftAxis.decimals = 0
        self.chartView.leftAxis.gridLineDashLengths = [4, 2]
        self.chartView.leftAxis.drawAxisLineEnabled = false
        self.chartView.leftAxis.labelPosition = .outsideChart
        self.chartView.leftAxis.labelXOffset = -4
        self.chartView.leftAxis.labelTextColor = GraphViewBase.axisLabelColor
        if let yAxisConfig = self.viewModel.yAxisConfig {
            self.chartView.leftAxis.valueFormatter = GraphAxisFormatter(config: yAxisConfig)
            self.chartView.leftAxis.setLabelCount(yAxisConfig.labels.count, force: true)
            self.chartView.leftAxis.axisMinimum = yAxisConfig.min
            self.chartView.leftAxis.axisMaximum = yAxisConfig.max
        }
        self.chartView.clipDataToContentEnabled = false

        self.chartView.delegate = self
    }

    private func select(entry: ChartDataEntry, interpolatedPoint: Bool) {
        if interpolatedPoint {
            clearPreviousSelectedEntry(shouldRestoreIcon: false)
        } else {
            clearPreviousSelectedEntry()
            self.selectedEntry = entry
            entry.icon = GraphConstants.selectedCircleIcon()
        }
        if let renderer = self.chartView.xAxisRenderer as? DKXAxisRenderer {
            renderer.selectedIndex = Int(entry.x)
        }
    }

    private func clearPreviousSelectedEntry(shouldRestoreIcon: Bool = true) {
        if shouldRestoreIcon {
            self.selectedEntry?.icon = self.defaultIcon
        }
        self.selectedEntry = nil
    }
}

extension LineGraphView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if entry != self.selectedEntry {
            let data: PointData? = entry.data as? PointData
            if let data {
                select(entry: entry, interpolatedPoint: data.interpolatedPoint)
                self.delegate?.graphDidSelectPoint((x: entry.x, y: entry.y, data: data))
            }
        }
    }
}
