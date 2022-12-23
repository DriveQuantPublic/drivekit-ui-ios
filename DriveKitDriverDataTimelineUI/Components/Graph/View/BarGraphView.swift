//
//  BarGraphView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import ChartsForDK

class BarGraphView: GraphViewBase {
    private let chartView: BarChartView
    private var selectedEntry: ChartDataEntry? = nil

    override init(viewModel: GraphViewModel) {
        self.chartView = BarChartView()
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
        var entries  = [BarChartDataEntry]()
        var entryToSelect: ChartDataEntry?
        for (index, point) in self.viewModel.points.enumerated() {
            if let point {
                let value = BarChartDataEntry(x: point.x, y: point.y, data: point.data)
                if index == self.viewModel.selectedIndex {
                    entryToSelect = value
                }
                entries.append(value)
            }
        }

        let bar = BarChartDataSet(entries: entries, label: nil)
        bar.colors = [.white]
        bar.barBorderColor = GraphConstants.defaultLineColor
        bar.barBorderWidth = 2
        bar.highlightEnabled = true
        bar.highlightColor = GraphConstants.defaultSelectedColor
        bar.highlightAlpha = 1
        bar.drawValuesEnabled = false

        let data = BarChartData()
        data.addDataSet(bar)
        data.highlightEnabled = true
        data.barWidth = 0.5

        self.chartView.data = data
        self.chartView.highlightPerTapEnabled = true
        self.chartView.pinchZoomEnabled = false
        self.chartView.scaleXEnabled = false
        self.chartView.scaleYEnabled = false
        self.chartView.dragEnabled = false
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.rightAxis.enabled = false
        self.chartView.legend.enabled = false
        self.chartView.extraRightOffset = 2

        self.chartView.xAxis.decimals = 0
        self.chartView.xAxis.drawAxisLineEnabled = false
        self.chartView.xAxis.drawGridLinesEnabled = false
        self.chartView.xAxis.labelPosition = .bottom
        if let xAxisConfig = self.viewModel.xAxisConfig {
            self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: xAxisConfig)
            self.chartView.xAxis.setLabelCount(xAxisConfig.labels.count, force: false)
            self.chartView.xAxis.axisMinimum = xAxisConfig.min - 0.5
            self.chartView.xAxis.axisMaximum = xAxisConfig.max + 0.5
        }

        self.chartView.leftAxis.decimals = 0
        self.chartView.leftAxis.gridLineDashLengths = [4, 2]
        self.chartView.leftAxis.drawAxisLineEnabled = false
        self.chartView.leftAxis.labelPosition = .outsideChart
        if let yAxisConfig = self.viewModel.yAxisConfig {
            self.chartView.leftAxis.valueFormatter = GraphAxisFormatter(config: yAxisConfig)
            self.chartView.leftAxis.setLabelCount(yAxisConfig.labels.count, force: true)
            self.chartView.leftAxis.axisMinimum = yAxisConfig.min
            self.chartView.leftAxis.axisMaximum = yAxisConfig.max
        }
        self.chartView.clipDataToContentEnabled = false

        self.chartView.delegate = self
        if let entryToSelect {
            select(entry: entryToSelect)
        }
    }

    private func select(entry: ChartDataEntry) {
        self.selectedEntry = entry
        self.chartView.highlightValue(x: entry.x, dataSetIndex: 0)
        if let renderer = self.chartView.xAxisRenderer as? DKXAxisRenderer {
            renderer.selectedIndex = Int(entry.x)
        }
    }
}

extension BarGraphView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if entry != self.selectedEntry {
            let data = entry.data as? PointData
            select(entry: entry)
            self.delegate?.graphDidSelectPoint((x: entry.x, y: entry.y, data: data))
        }
    }
}
