//
//  VelocityChartView.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 25/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import Charts
import DriveKitCommonUI

class VelocityChartView: LineChartView {
    private let maxPoints: Int = 30
    private var graphData: [ChartDataEntry] = []
    private var graphDataSet: LineChartDataSet!

    func setupChart() {
        self.dragEnabled = false
        self.setScaleEnabled(false)
        self.pinchZoomEnabled = false
        self.xAxis.enabled = true
        self.rightAxis.enabled = false
        self.leftAxis.enabled = true
        self.legend.enabled = true

        let legend = self.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true

        let yAxis = self.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 12, weight: .semibold)
        yAxis.setLabelCount(5, force: false)
        yAxis.labelTextColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .black

        let xAxis = self.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .semibold)
        xAxis.setLabelCount(2, force: false)
        xAxis.labelTextColor = .black
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = .black

        self.chartDescription?.text = "trip_simulator_graph_time".keyLocalized()
        
        let dataSet = LineChartDataSet(entries:  self.graphData, label: "trip_simulator_graph_velocity".keyLocalized())
        dataSet.mode = .linear
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(DKUIColors.primaryColor.color)
        dataSet.drawValuesEnabled = false

        let data = LineChartData(dataSet: dataSet)
        self.data = data
    }

    func updateGraph(velocity: Double, timestamp: Double) {
        let dataSetIndex = 0
        let newPoint = ChartDataEntry(x: Double(timestamp), y: velocity)
        graphData.append(newPoint)
        self.data?.addEntry(newPoint, dataSetIndex: dataSetIndex)
        if graphData.count > self.maxPoints {
            let oldEntry = graphData.removeFirst()
            self.data?.removeEntry(oldEntry, dataSetIndex: dataSetIndex)
        }
        self.notifyDataSetChanged()
    }

    func clean() {
        while graphData.count > 0 {
            let oldEntry = graphData.removeFirst()
            self.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        self.notifyDataSetChanged()
    }
}