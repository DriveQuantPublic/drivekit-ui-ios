//
//  BarGraphView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import ChartsForDK

//TODO
class BarGraphView: GraphViewBase {
    private let chartView: BarChartView

    override init(viewModel: GraphViewModel) {
        self.chartView = BarChartView()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getChartView() -> BarLineChartViewBase? {
        return self.chartView
    }

    override func setupData() {
        var lineChartEntry  = [BarChartDataEntry]()

        let numbers: [Double] = [3.4, 3.5, 4, 3.2, 1.1, 4.9, 4.3, 1.4]
        for i in 0..<numbers.count {
            let value = BarChartDataEntry(x: Double(i), y: numbers[i])
//            value.icon = self.defaultIcon
            lineChartEntry.append(value)
        }

        let line1 = BarChartDataSet(entries: lineChartEntry, label: nil)
        line1.colors = [.blue]
        //        line1.setCircleColor(.cyan)
        line1.highlightEnabled = true
        line1.highlightColor = .orange

        let data = BarChartData()
        data.addDataSet(line1)
        data.highlightEnabled = true

        self.chartView.data = data
        //        self.chartView.xAxis.drawLabelsEnabled = true
        self.chartView.highlightPerTapEnabled = true
        self.chartView.pinchZoomEnabled = false
        self.chartView.scaleXEnabled = false
        self.chartView.scaleYEnabled = false
        self.chartView.dragEnabled = false
        self.chartView.doubleTapToZoomEnabled = false

        self.chartView.xAxis.valueFormatter = GraphAxisFormatter(config: self.viewModel.xAxisConfig)
        self.chartView.xAxis.labelCount = 8
        self.chartView.xAxis.axisMinimum = 0
        self.chartView.xAxis.axisMaximum = 8
        self.chartView.xAxis.labelPosition = .bottom

        self.chartView.delegate = self
    }
}

extension BarGraphView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\(highlight.x) - \(highlight.y)")
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
