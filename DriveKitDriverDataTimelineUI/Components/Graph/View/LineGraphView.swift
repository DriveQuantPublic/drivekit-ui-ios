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
    private let defaultIcon = DKImages.info.image //UIImage(systemName: "circle.circle.fill")

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

        for point in self.viewModel.points {
            let value = ChartDataEntry(x: point.x, y: point.y, data: point.data)
            //            value.icon = self.defaultIcon
            lineChartEntry.append(value)
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: nil)
        line1.colors = [UIColor(hex: 0x083B54)]
        line1.drawVerticalHighlightIndicatorEnabled = false
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.highlightEnabled = true
        line1.drawValuesEnabled = false
        line1.drawCirclesEnabled = false

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
            self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: xAxisConfig, debug: "X")
            self.chartView.xAxis.setLabelCount(xAxisConfig.labels.count, force: true)
            self.chartView.xAxis.decimals = 0
            self.chartView.xAxis.axisMinimum = xAxisConfig.min
            self.chartView.xAxis.axisMaximum = xAxisConfig.max
        }
        self.chartView.xAxis.labelPosition = .bottom

        if let yAxisConfig = self.viewModel.yAxisConfig {
            self.chartView.leftAxis.valueFormatter = GraphAxisFormatter(config: yAxisConfig, debug: "Y")
            self.chartView.leftAxis.setLabelCount(yAxisConfig.labels.count, force: true)
            self.chartView.leftAxis.decimals = 0
            self.chartView.leftAxis.axisMinimum = yAxisConfig.min
            self.chartView.leftAxis.axisMaximum = yAxisConfig.max
        }
        self.chartView.leftAxis.labelPosition = .outsideChart

        self.chartView.delegate = self
    }
}

extension LineGraphView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\(highlight.x) - \(highlight.y)  -  \(entry.x) - \(entry.y)")
        self.delegate?.graphDidSelectPoint((x: entry.x, y: entry.y, data: entry.data))
//        selectedEntry?.icon = defaultIcon
//        if let dataSet = chartView.data?.dataSets.first as? LineChartDataSet {
//            //            dataSet.circleHoleColor = .green
//            selectedEntry = dataSet.entries[Int(highlight.x)]
//            selectedEntry?.icon = self.defaultIcon?.withTintColor(.red)
//        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
//        (chartView.data?.dataSets.first as? LineChartDataSet)?.circleHoleColor = .clear
//        selectedEntry?.icon = defaultIcon
//        selectedEntry = nil
    }
}
