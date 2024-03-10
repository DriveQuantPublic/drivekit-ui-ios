// swiftlint:disable all
//
//  TimelineGraphViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

class TimelineGraphViewModel: GraphViewModel {
    weak var delegate: TimelineGraphDelegate?
    var graphViewModelDidUpdate: (() -> Void)?
    private(set) var points: [GraphPoint?] = []
    private(set) var type: GraphType = .line
    private(set) var selectedIndex: Int?
    private(set) var xAxisConfig: GraphAxisConfig?
    private(set) var yAxisConfig: GraphAxisConfig?
    private(set) var title: String = ""
    private(set) var description: String = ""
    private var sourceDates: [Date]?
    private var timelineSelectedIndex: Int?
    private var indexOfFirstPointInTimeline: Int?
    private var indexOfLastPointInTimeline: Int?
    private static let graphPointNumber: Int = 8
    
    func configure(timeline: DKDriverTimeline, dates: [Date], timelineSelectedIndex: Int, graphItem: GraphItem, period: DKPeriod) {
        let sourceDates = dates
        let dates: [Date] = sourceDates.map { date in
            date.dateByRemovingTime() ?? date
        }
        let dateComponent = dateComponent(for: period)
        let graphPointNumber = Self.graphPointNumber
        let selectedDate = dates[timelineSelectedIndex]
        let now = Date()
        let currentDate = now.beginning(relativeTo: dateComponent)
        guard
            let currentDate,
            let delta = selectedDate.diffWith(date: currentDate, countingIn: dateComponent)
        else { return }
        self.sourceDates = sourceDates
        self.timelineSelectedIndex = timelineSelectedIndex
        let selectedIndexInGraph = (graphPointNumber - 1) - (delta % graphPointNumber)
        let graphStartDate = selectedDate.date(byAdding: -selectedIndexInGraph, calendarUnit: dateComponent)
        let graphDates: [String] = graphLabelsFrom(startDate: graphStartDate, dateComponent: dateComponent, period: period, graphPointNumber: graphPointNumber)
        var graphPoints: [GraphPoint?] = []
        for i in 0..<graphPointNumber {
            let xLabelDate: Date? = graphStartDate?.date(byAdding: i, calendarUnit: dateComponent)
            var point: GraphPoint?
            if let xLabelDate {
                let shouldInterpolate = graphItem.graphType == .line
                if let xLabelDateIndex = dates.firstIndex(of: xLabelDate) {
                    if let value = getValue(atIndex: xLabelDateIndex, for: graphItem, in: timeline) {
                        point = (x: Double(i), y: value, data: PointData(date: sourceDates[xLabelDateIndex], interpolatedPoint: false))
                    } else if shouldInterpolate {
                        point = interpolateSelectableDateWithoutValue(
                            fromDateIndex: xLabelDateIndex,
                            graphItem: graphItem,
                            timeline: timeline,
                            dates: dates,
                            dateComponent: dateComponent,
                            pointX: Double(i),
                            sourceDates: sourceDates
                        )
                    }
                } else if shouldInterpolate {
                    if let graphStartDate {
                        if i == 0 {
                            point = interpolateStartOfGraph(
                                from: graphStartDate,
                                dateComponent: dateComponent,
                                dates: dates,
                                graphItem: graphItem,
                                timeline: timeline,
                                xLabelDate: xLabelDate
                            )
                        } else if i == graphPointNumber - 1 {
                            point = interpolateEndOfGraph(
                                from: graphStartDate,
                                dateComponent: dateComponent,
                                dates: dates,
                                graphItem: graphItem,
                                timeline: timeline,
                                xLabelDate: xLabelDate
                            )
                        }
                    }
                }
            }
            graphPoints.append(point)
            computeIndexOfFirstAndLastPointInTimeline(from: graphPoints)
        }
        configure(
            graphItem: graphItem,
            graphPointNumber: graphPointNumber,
            graphPoints: graphPoints,
            graphDates: graphDates,
            selectedIndex: selectedIndexInGraph,
            graphDescription: graphItem.getGraphDescription(
                fromValue: getValue(
                    atIndex: timelineSelectedIndex,
                    for: graphItem,
                    in: timeline
                )
            )
        )
    }
    
    func showEmptyGraph(graphItem: GraphItem, period: DKPeriod) {
        let dateComponent = dateComponent(for: period)
        let graphPointNumber = Self.graphPointNumber
        let now = Date()
        if let currentDate = now.beginning(relativeTo: dateComponent) {
            let startDate = currentDate.date(byAdding: -graphPointNumber + 1, calendarUnit: dateComponent)
            let graphDates: [String] = graphLabelsFrom(startDate: startDate, dateComponent: dateComponent, period: period, graphPointNumber: graphPointNumber)
            let graphPoints: [GraphPoint?] = [(x: 0, y: 10, data: nil)]
            configure(graphItem: graphItem, graphPointNumber: graphPointNumber, graphPoints: graphPoints, graphDates: graphDates, selectedIndex: nil, graphDescription: "-")
        }
    }
    
    func showPreviousGraphData() {
        if let delegate = self.delegate, let sourceDates = self.sourceDates, let indexOfFirstPointInTimeline = self.indexOfFirstPointInTimeline {
            if indexOfFirstPointInTimeline > 0 {
                delegate.graphDidSelectDate(sourceDates[indexOfFirstPointInTimeline - 1])
            } else if let timelineSelectedIndex = self.timelineSelectedIndex, timelineSelectedIndex != indexOfFirstPointInTimeline {
                delegate.graphDidSelectDate(sourceDates[indexOfFirstPointInTimeline])
            }
        }
    }
    
    func showNextGraphData() {
        if let delegate = self.delegate, let sourceDates = self.sourceDates, let indexOfLastPointInTimeline = self.indexOfLastPointInTimeline {
            if indexOfLastPointInTimeline < sourceDates.count - 1 {
                delegate.graphDidSelectDate(sourceDates[indexOfLastPointInTimeline + 1])
            } else if let timelineSelectedIndex = self.timelineSelectedIndex, timelineSelectedIndex != indexOfLastPointInTimeline {
                delegate.graphDidSelectDate(sourceDates[indexOfLastPointInTimeline])
            }
        }
    }
    
    private func configure(
        graphItem: GraphItem,
        graphPointNumber: Int,
        graphPoints: [GraphPoint?],
        graphDates: [String],
        selectedIndex: Int?,
        graphDescription: String
    ) {
        self.type = graphItem.graphType
        self.points = graphPoints
        self.selectedIndex = selectedIndex
        self.xAxisConfig = GraphAxisConfig(min: 0, max: Double(graphPointNumber - 1), labels: .customLabels(graphDates))
        let minYValue = graphItem.graphMinValue
        let maxYValue = graphItem.graphMaxValue(forRealMaxValue: graphPoints.map { $0?.y ?? 0 }.max())
        self.yAxisConfig = GraphAxisConfig(min: minYValue, max: maxYValue, labels: .rawValues(labelCount: graphItem.maxNumberOfLabels(forMaxValue: maxYValue)))
        self.title = graphItem.graphTitle
        self.description = graphDescription
        self.graphViewModelDidUpdate?()
    }
    
    private func graphLabelsFrom(startDate: Date?, dateComponent: Calendar.Component, period: DKPeriod, graphPointNumber: Int) -> [String] {
        var graphDates: [String] = []
        for i in 0..<graphPointNumber {
            let date: Date? = startDate?.date(byAdding: i, calendarUnit: dateComponent)
            let dateString: String
            if let date {
                dateString = date.format(pattern: dateFormatPattern(for: period))
            } else {
                dateString = ""
            }
            graphDates.append(dateString)
        }
        return graphDates
    }
    
    private func previousIndexWithValue(from startIndex: Int, hasValueAtIndex: (Int) -> Bool) -> Int? {
        var previousValidIndex: Int?
        var currentIndex = startIndex
        while previousValidIndex == nil && currentIndex > 0 {
            currentIndex -= 1
            if hasValueAtIndex(currentIndex) {
                previousValidIndex = currentIndex
                break
            }
        }
        return previousValidIndex
    }
    
    private func nextIndexWithValue(from startIndex: Int, to maxIndex: Int, hasValueAtIndex: (Int) -> Bool) -> Int? {
        var nextValidIndex: Int?
        var currentIndex = startIndex
        while nextValidIndex == nil && currentIndex < maxIndex - 1 {
            currentIndex += 1
            if hasValueAtIndex(currentIndex) {
                nextValidIndex = currentIndex
                break
            }
        }
        return nextValidIndex
    }
    
    private func interpolateStartOfGraph(
        from graphStartDate: Date,
        dateComponent: Calendar.Component,
        dates: [Date],
        graphItem: GraphItem,
        timeline: DKDriverTimeline,
        xLabelDate: Date
    ) -> GraphPoint? {
        // Find next valid index
        var point: GraphPoint?
        var nextValidIndex: Int?
        var i = 0
        var hasMoreKnownDates = true
        let lastDate = dates.last!
        while nextValidIndex == nil && hasMoreKnownDates {
            i += 1
            guard let nextValidDate = graphStartDate.date(byAdding: i, calendarUnit: dateComponent) else {
                preconditionFailure("We should always be able to add one \(dateComponent) to date: \(graphStartDate)")
            }
            nextValidIndex = dates.firstIndex(of: nextValidDate)
            if let index = nextValidIndex {
                if getValue(atIndex: index, for: graphItem, in: timeline) == nil {
                    nextValidIndex = nil
                }
            }
            hasMoreKnownDates = nextValidDate <= lastDate
        }
        if let nextValidIndex, nextValidIndex > 0 {
            var previousValidIndex: Int = nextValidIndex - 1
            while previousValidIndex >= 0 && getValue(atIndex: previousValidIndex, for: graphItem, in: timeline) == nil {
                previousValidIndex -= 1
            }
            if previousValidIndex >= 0 {
                if let interpolatedValue = interpolateValueFrom(
                    date: xLabelDate,
                    previousValidIndex: previousValidIndex,
                    nextValidIndex: nextValidIndex,
                    dates: dates,
                    dateComponent: dateComponent,
                    graphItem: graphItem,
                    timeline: timeline
                ) {
                    point = (x: Double(0), y: interpolatedValue, data: nil)
                }
            }
        }
        return point
    }
    
    private func interpolateEndOfGraph(
        from graphStartDate: Date,
        dateComponent: Calendar.Component,
        dates: [Date],
        graphItem: GraphItem,
        timeline: DKDriverTimeline,
        xLabelDate: Date
    ) -> GraphPoint? {
        // Find previous valid index
        var point: GraphPoint?
        var previousValidIndex: Int?
        var i = Self.graphPointNumber - 1
        var hasMoreKnownDates = true
        let firstDate = dates.first!
        while previousValidIndex == nil && hasMoreKnownDates {
            i -= 1
            guard let previousValidDate = graphStartDate.date(byAdding: i, calendarUnit: dateComponent) else {
                preconditionFailure("We should always be able to add one \(dateComponent) to date: \(graphStartDate)")
            }
            previousValidIndex = dates.firstIndex(of: previousValidDate)
            if let index = previousValidIndex {
                if getValue(atIndex: index, for: graphItem, in: timeline) == nil {
                    previousValidIndex = nil
                }
            }
            hasMoreKnownDates = previousValidDate >= firstDate
        }
        let max = dates.count
        if let previousValidIndex, previousValidIndex < max - 1 {
            var nextValidIndex: Int = previousValidIndex + 1
            while nextValidIndex < max && getValue(atIndex: nextValidIndex, for: graphItem, in: timeline) == nil {
                nextValidIndex += 1
            }
            if nextValidIndex < max {
                if let interpolatedValue = interpolateValueFrom(
                    date: xLabelDate,
                    previousValidIndex: previousValidIndex,
                    nextValidIndex: nextValidIndex,
                    dates: dates,
                    dateComponent: dateComponent,
                    graphItem: graphItem,
                    timeline: timeline
                ) {
                    point = (x: Double(Self.graphPointNumber - 1), y: interpolatedValue, data: nil)
                }
            }
        }
        return point
    }
    
    private func interpolateSelectableDateWithoutValue(
        fromDateIndex dateIndex: Int,
        graphItem: GraphItem,
        timeline: DKDriverTimeline,
        dates: [Date],
        dateComponent: Calendar.Component,
        pointX: Double,
        sourceDates: [Date]
    ) -> GraphPoint? {
        let point: GraphPoint?
        if dates.count == 1 {
            point = (x: pointX, y: 0, data: nil)
        } else {
            let previousIndexWithValue = previousIndexWithValue(from: dateIndex) { index in
                getValue(atIndex: index, for: graphItem, in: timeline) != nil
            }
            let nextIndexWithValue = nextIndexWithValue(from: dateIndex, to: dates.count) { index in
                getValue(atIndex: index, for: graphItem, in: timeline) != nil
            }
            if let previousIndexWithValue, let nextIndexWithValue, let interpolatedValue = interpolateValueFrom(
                date: dates[dateIndex],
                previousValidIndex: previousIndexWithValue,
                nextValidIndex: nextIndexWithValue,
                dates: dates,
                dateComponent: dateComponent,
                graphItem: graphItem,
                timeline: timeline
            ) {
                point = (x: pointX, y: interpolatedValue, data: PointData(date: sourceDates[dateIndex], interpolatedPoint: true))
            } else {
                point = nil
            }
        }
        return point
    }
    
    private func computeIndexOfFirstAndLastPointInTimeline(from graphPoints: [GraphPoint?]) {
        self.indexOfFirstPointInTimeline = nil
        self.indexOfLastPointInTimeline = nil
        if let sourceDates = self.sourceDates {
            for graphPoint in graphPoints {
                if let data = graphPoint?.data, !data.interpolatedPoint {
                    if self.indexOfFirstPointInTimeline == nil {
                        self.indexOfFirstPointInTimeline = sourceDates.firstIndex(of: data.date)
                    }
                    self.indexOfLastPointInTimeline = sourceDates.firstIndex(of: data.date)
                }
            }
        }
    }
    
    private func dateComponent(for period: DKPeriod) -> Calendar.Component {
        let dateComponent: Calendar.Component
        switch period {
            case .week:
                dateComponent = .weekOfYear
            case .month:
                dateComponent = .month
            case .year:
                fallthrough
            @unknown default:
                fatalError("Unknown value: \(period)")
        }
        return dateComponent
    }
    
    private func dateFormatPattern(for period: DKPeriod) -> DKDatePattern {
        let dateFormat: DKDatePattern
        switch period {
            case .week:
                dateFormat = DKDatePattern.dayMonth
            case .month:
                dateFormat = DKDatePattern.monthAbbreviation
            case .year:
                fallthrough
            @unknown default:
                fatalError("Unknown value: \(period)")
        }
        return dateFormat
    }
    
    private func getValue(atIndex index: Int, for graphItem: GraphItem, in timeline: DKDriverTimeline) -> Double? {
        let allContextItem = timeline.allContext[index]
        let totalDuration = Double(allContextItem.duration)
        let totalDistance = allContextItem.distance

        switch graphItem {
        case .score(let scoreType):
            switch scoreType {
            case .safety:
                return allContextItem.safety?.score
            case .distraction:
                return allContextItem.phoneDistraction?.score
            case .ecoDriving:
                return allContextItem.ecoDriving?.score
            case .speeding:
                return allContextItem.speeding?.score
            @unknown default:
                return nil
            }
        case .scoreItem(let scoreItemType):
            switch scoreItemType {
            case .speeding_duration:
                guard let speedingDuration = allContextItem.speeding?.speedingDuration else { return nil }
                guard totalDuration > 0 else { return 0 }
                return (Double(speedingDuration) / 60) / totalDuration * 100
            case .speeding_distance:
                guard let speedingDistance = allContextItem.speeding?.speedingDistance else { return nil }
                guard totalDuration > 0 else { return 0 }
                return (speedingDistance / 1_000) / totalDistance * 100
            case .safety_braking:
                guard let braking = allContextItem.safety?.braking else { return nil }
                guard totalDistance > 0 else { return 0 }
                return Double(braking) / (totalDistance / 100)
            case .safety_adherence:
                guard let adherence = allContextItem.safety?.adherence else { return nil }
                guard totalDistance > 0 else { return 0 }
                return Double(adherence) / (totalDistance / 100)
            case .safety_acceleration:
                guard let acceleration = allContextItem.safety?.acceleration else { return nil }
                guard totalDistance > 0 else { return 0 }
                return Double(acceleration) / (totalDistance / 100)
            case .ecoDriving_fuelVolume:
                return allContextItem.ecoDriving?.fuelVolume
            case .ecoDriving_efficiencySpeedMaintain:
                return allContextItem.ecoDriving?.efficiencySpeedMaintain
            case .ecoDriving_efficiencyBrake:
                return allContextItem.ecoDriving?.efficiencyBrake
            case .ecoDriving_efficiencyAcceleration:
                return allContextItem.ecoDriving?.efficiencyAcceleration
            case .ecoDriving_fuelSavings:
                return allContextItem.ecoDriving?.fuelSaving
            case .ecoDriving_co2mass:
                return allContextItem.ecoDriving?.co2Mass
            case .distraction_unlock:
                guard let unlock = allContextItem.phoneDistraction?.unlock else { return nil }
                guard totalDistance > 0 else { return 0 }
                return Double(unlock) / (totalDistance / 100)
            case .distraction_percentageOfTripsWithForbiddenCall:
                guard let phoneDistraction = allContextItem.phoneDistraction else { return nil }
                let numberTripTotal = allContextItem.numberTripTotal
                guard numberTripTotal > 0 else { return 0 }
                let numberTripWithForbiddenCall = phoneDistraction.numberTripWithForbiddenCall
                return Double(numberTripWithForbiddenCall) / Double(numberTripTotal) * 100
            case .distraction_callForbiddenDuration:
                guard let callForbiddenDuration = allContextItem.phoneDistraction?.callForbiddenDuration else { return nil }
                guard totalDistance > 0 else { return 0 }
                // The result is converted in minute and rounded up to greater integer value
                return ceil(Double(callForbiddenDuration / 60) / (totalDistance / 100))
            }
        }
    }
    
    private func interpolateValueFrom(
        date: Date,
        previousValidIndex: Int,
        nextValidIndex: Int,
        dates: [Date],
        dateComponent: Calendar.Component,
        graphItem: GraphItem,
        timeline: DKDriverTimeline
    ) -> Double? {
        let previousValidDate: Date = dates[previousValidIndex]
        let nextValidDate: Date = dates[nextValidIndex]
        let diffBetweenPreviousAndNext = previousValidDate.diffWith(date: nextValidDate, countingIn: dateComponent)
        let diffBetweenPreviousAndDate = previousValidDate.diffWith(date: date, countingIn: dateComponent)
        let previousValue = getValue(atIndex: previousValidIndex, for: graphItem, in: timeline)
        let nextValue = getValue(atIndex: nextValidIndex, for: graphItem, in: timeline)
        if let previousValue, let nextValue, let diffBetweenPreviousAndNext, let diffBetweenPreviousAndDate {
            let valueDelta = nextValue - previousValue
            let interpolatedValue = previousValue + valueDelta * Double(diffBetweenPreviousAndDate) / Double(diffBetweenPreviousAndNext)
            return interpolatedValue
        } else {
            return nil
        }
    }
}

extension TimelineGraphViewModel: GraphViewDelegate {
    func graphDidSelectPoint(_ point: GraphPoint) {
        if let data = point.data {
            self.delegate?.graphDidSelectDate(data.date)
        }
    }
}
