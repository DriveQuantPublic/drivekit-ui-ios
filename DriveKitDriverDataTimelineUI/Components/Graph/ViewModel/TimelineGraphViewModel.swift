//
//  TimelineGraphViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule
import DriveKitCommonUI

class TimelineGraphViewModel: GraphViewModel {
    weak var delegate: TimelineGraphDelegate?
    var graphViewModelDidUpdate: (() -> ())?
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
    private static let formatter = DateFormatter()
    private static let graphPointNumber: Int = 8

    func configure(timeline: DKTimeline, timelineSelectedIndex: Int, graphItem: GraphItem, period: DKTimelinePeriod) {
        let sourceDates = timeline.allContext.date
        let dates: [Date] = sourceDates.map { date in
            date.dateByRemovingTime() ?? date
        }
        let dateComponent = dateComponent(for: period)
        let dateFormat = dateFormat(for: period)
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
        self.indexOfFirstPointInTimeline = nil
        self.indexOfLastPointInTimeline = nil
        let selectedIndexInGraph = (graphPointNumber - 1) - (delta % graphPointNumber)
        let graphStartDate = selectedDate.date(byAdding: -selectedIndexInGraph, component: dateComponent)
        TimelineGraphViewModel.formatter.dateFormat = dateFormat
        let graphDates: [String] = graphLabelsFrom(startDate: graphStartDate, dateComponent: dateComponent, graphPointNumber: graphPointNumber)
        var graphPoints: [GraphPoint?] = []
        for i in 0..<graphPointNumber {
            let xLabelDate: Date? = graphStartDate?.date(byAdding: i, component: dateComponent)
            var point: GraphPoint? = nil
            if let xLabelDate {
                let shouldInterpolate = graphItem.graphType == .line
                if let xLabelDateIndex = dates.firstIndex(of: xLabelDate) {
                    if let value = getValue(atIndex: xLabelDateIndex, for: graphItem, in: timeline) {
                        point = (x: Double(i), y: value, data: PointData(date: sourceDates[xLabelDateIndex], interpolatedPoint: false))
                        if self.indexOfFirstPointInTimeline == nil {
                            self.indexOfFirstPointInTimeline = xLabelDateIndex
                        }
                        self.indexOfLastPointInTimeline = xLabelDateIndex
                    } else if shouldInterpolate {
                        // Append "invisible point" (by interpolation)
                        let previousIndexWithValue = previousIndexWithValue(from: xLabelDateIndex) { index in
                            getValue(atIndex: index, for: graphItem, in: timeline) != nil
                        }
                        let nextIndexWithValue = nextIndexWithValue(from: xLabelDateIndex, to: dates.count) { index in
                            getValue(atIndex: index, for: graphItem, in: timeline) != nil
                        }
                        if let previousIndexWithValue, let nextIndexWithValue {
                            if let interpolatedValue = interpolateValueFrom(date: xLabelDate, previousValidIndex: previousIndexWithValue, nextValidIndex: nextIndexWithValue, dates: dates, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                                point = (x: Double(i), y: interpolatedValue, data: PointData(date: sourceDates[xLabelDateIndex], interpolatedPoint: true))
                            }
                        }
                    }
                } else if shouldInterpolate {
                    if let graphStartDate {
                        if i == 0 {
                            point = interpolateStartOfGraph(from: graphStartDate, dateComponent: dateComponent, dates: dates, graphItem: graphItem, timeline: timeline, xLabelDate: xLabelDate)
                        } else if i == graphPointNumber - 1 {
                            point = interpolateEndOfGraph(from: graphStartDate, dateComponent: dateComponent, dates: dates, graphItem: graphItem, timeline: timeline, xLabelDate: xLabelDate)
                        }
                    }
                }
            }
            graphPoints.append(point)
        }
        configure(graphItem: graphItem, graphPointNumber: graphPointNumber, graphPoints: graphPoints, graphDates: graphDates, selectedIndex: selectedIndexInGraph, graphDescription: graphItem.getGraphDescription(fromValue: getValue(atIndex: timelineSelectedIndex, for: graphItem, in: timeline)))
    }

    func showEmptyGraph(graphItem: GraphItem, period: DKTimelinePeriod) {
        let dateComponent = dateComponent(for: period)
        let dateFormat = dateFormat(for: period)
        let graphPointNumber = Self.graphPointNumber
        let now = Date()
        if let currentDate = now.beginning(relativeTo: dateComponent) {
            let startDate = currentDate.date(byAdding: -graphPointNumber + 1, component: dateComponent)
            TimelineGraphViewModel.formatter.dateFormat = dateFormat
            let graphDates: [String] = graphLabelsFrom(startDate: startDate, dateComponent: dateComponent, graphPointNumber: graphPointNumber)
            let graphPoints: [GraphPoint?] = [(x: 0, y: 10, data: nil)]
            configure(graphItem: graphItem, graphPointNumber: graphPointNumber, graphPoints: graphPoints, graphDates: graphDates, selectedIndex: nil, graphDescription: "-")
        }
    }

    func showPreviousGraphData() {
        if let delegate = self.delegate, let sourceDates = self.sourceDates, let indexOfFirstPointInTimeline = self.indexOfFirstPointInTimeline {
            if indexOfFirstPointInTimeline > 0 {
                delegate.graphDidSelectDate(sourceDates[indexOfFirstPointInTimeline - 1])
            } else if let timelineSelectedIndex = self.timelineSelectedIndex, timelineSelectedIndex != indexOfLastPointInTimeline {
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

    private func configure(graphItem: GraphItem, graphPointNumber: Int, graphPoints: [GraphPoint?], graphDates: [String], selectedIndex: Int?, graphDescription: String) {
        self.type = graphItem.graphType
        self.points = graphPoints
        self.selectedIndex = selectedIndex
        self.xAxisConfig = GraphAxisConfig(min: 0, max: Double(graphPointNumber - 1), labels: graphDates)
        let minYValue = graphItem.graphMinValue
        var labels: [String] = []
        for i in Int(minYValue)...10 {
            labels.append("\(i)")
        }
        self.yAxisConfig = GraphAxisConfig(min: graphItem.graphMinValue, max: 10, labels: labels)
        self.title = graphItem.graphTitle
        self.description = graphDescription
        self.graphViewModelDidUpdate?()
    }

    private func graphLabelsFrom(startDate: Date?, dateComponent: Calendar.Component, graphPointNumber: Int) -> [String] {
        var graphDates: [String] = []
        for i in 0..<graphPointNumber {
            let date: Date? = startDate?.date(byAdding: i, component: dateComponent)
            let dateString: String
            if let date {
                dateString = TimelineGraphViewModel.formatter.string(from: date)
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

    private func interpolateStartOfGraph(from graphStartDate: Date, dateComponent: Calendar.Component, dates: [Date], graphItem: GraphItem, timeline: DKTimeline, xLabelDate: Date) -> GraphPoint? {
        // Find next valid index
        var point: GraphPoint? = nil
        var nextValidIndex: Int?
        var i = 0
        while nextValidIndex == nil {
            i += 1
            if let nextValidDate = graphStartDate.date(byAdding: i, component: dateComponent) {
                nextValidIndex = dates.firstIndex(of: nextValidDate)
                if let index = nextValidIndex {
                    if getValue(atIndex: index, for: graphItem, in: timeline) == nil {
                        nextValidIndex = nil
                    }
                }
            }
        }
        if let nextValidIndex, nextValidIndex > 0 {
            var previousValidIndex: Int = nextValidIndex - 1
            while previousValidIndex >= 0 && getValue(atIndex: previousValidIndex, for: graphItem, in: timeline) == nil {
                previousValidIndex -= 1
            }
            if previousValidIndex >= 0 {
                if let interpolatedValue = interpolateValueFrom(date: xLabelDate, previousValidIndex: previousValidIndex, nextValidIndex: nextValidIndex, dates: dates, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                    point = (x: Double(0), y: interpolatedValue, data: nil)
                }
            }
        }
        return point
    }

    private func interpolateEndOfGraph(from graphStartDate: Date, dateComponent: Calendar.Component, dates: [Date], graphItem: GraphItem, timeline: DKTimeline, xLabelDate: Date) -> GraphPoint? {
        // Find previous valid index
        var point: GraphPoint? = nil
        var previousValidIndex: Int?
        var index = Self.graphPointNumber - 1
        while previousValidIndex == nil {
            index -= 1
            if let previousValidDate = graphStartDate.date(byAdding: index, component: dateComponent) {
                previousValidIndex = dates.firstIndex(of: previousValidDate)
                if let index = previousValidIndex {
                    if getValue(atIndex: index, for: graphItem, in: timeline) == nil {
                        previousValidIndex = nil
                    }
                }
            }
        }
        let max = dates.count
        if let previousValidIndex, previousValidIndex < max - 1 {
            var nextValidIndex: Int = previousValidIndex + 1
            while nextValidIndex < max && getValue(atIndex: nextValidIndex, for: graphItem, in: timeline) == nil {
                nextValidIndex += 1
            }
            if nextValidIndex < max {
                if let interpolatedValue = interpolateValueFrom(date: xLabelDate, previousValidIndex: previousValidIndex, nextValidIndex: nextValidIndex, dates: dates, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                    point = (x: Double(Self.graphPointNumber - 1), y: interpolatedValue, data: nil)
                }
            }
        }
        return point
    }

    private func dateComponent(for period: DKTimelinePeriod) -> Calendar.Component {
        let dateComponent: Calendar.Component
        switch period {
            case .week:
                dateComponent = .weekOfYear
            case .month:
                dateComponent = .month
            @unknown default:
                fatalError("Unknown value: \(period)")
        }
        return dateComponent
    }

    private func dateFormat(for period: DKTimelinePeriod) -> String {
        let dateFormat: String
        switch period {
            case .week:
                dateFormat = DKDatePattern.dayMonth.rawValue
            case .month:
                dateFormat = DKDatePattern.monthAbbreviation.rawValue
            @unknown default:
                fatalError("Unknown value: \(period)")
        }
        return dateFormat
    }

    private func getValue(atIndex index: Int, for graphItem: GraphItem, in timeline: DKTimeline) -> Double? {
        switch graphItem {
            case .score(let scoreType):
                switch scoreType {
                    case .safety:
                        if timeline.allContext.numberTripScored[index] > 0 {
                            return timeline.allContext.safety[index]
                        } else {
                            return nil
                        }
                    case .distraction:
                        return timeline.allContext.phoneDistraction[index]
                    case .ecoDriving:
                        if timeline.allContext.numberTripScored[index] > 0 {
                            return timeline.allContext.efficiency[index]
                        } else {
                            return nil
                        }
                    case .speeding:
                        return timeline.allContext.speeding[index]
                }
            case .scoreItem(let scoreItemType):
                switch scoreItemType {
                    case .speeding_duration:
                        return Double(timeline.allContext.speedingDuration[index])
                    case .speeding_distance:
                        return timeline.allContext.speedingDistance[index]
                    case .safety_braking:
                        return Double(timeline.allContext.braking[index])
                    case .safety_adherence:
                        return Double(timeline.allContext.adherence[index])
                    case .safety_acceleration:
                        return Double(timeline.allContext.acceleration[index])
                    case .ecoDriving_fuelVolume:
                        return timeline.allContext.fuelVolume[index]
                    case .ecoDriving_efficiencySpeedMaintain:
                        return timeline.allContext.efficiencySpeedMaintain[index]
                    case .ecoDriving_efficiencyBrake:
                        return timeline.allContext.efficiencyBrake[index]
                    case .ecoDriving_efficiencyAcceleration:
                        return timeline.allContext.efficiencyAcceleration[index]
                    case .ecoDriving_fuelSavings:
                        #warning("TODO")
                        return 0
                    case .ecoDriving_co2mass:
                        return timeline.allContext.co2Mass[index]
                    case .distraction_unlock:
                        return Double(timeline.allContext.unlock[index])
                    case .distraction_percentageOfTripsWithForbiddenCall:
                        return Double(timeline.allContext.numberTripWithForbiddenCall[index]) / Double(timeline.allContext.numberTripTotal[index])
                    case .distraction_callForbiddenDuration:
                        return Double(timeline.allContext.callForbidden[index])
                }
        }
    }

    private func interpolateValueFrom(date: Date, previousValidIndex: Int, nextValidIndex: Int, dates: [Date], dateComponent: Calendar.Component, graphItem: GraphItem, timeline: DKTimeline) -> Double? {
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
        if let data = point.data  {
            self.delegate?.graphDidSelectDate(data.date)
        }
    }
}
