//
//  TimelineGraphViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

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

    func configure(timeline: DKTimeline, timelineIndex: Int, graphItem: GraphItem, period: DKTimelinePeriod) {
        let sourceDates = timeline.allContext.date
        let dates: [Date] = sourceDates.map { date in
            date.dateByRemovingTime() ?? date
        }
        let dateComponent: Calendar.Component
        let dateFormat: String
        let graphPointNumber: Int
        switch period {
            case .week:
                dateComponent = .weekOfYear
                dateFormat = "dd/MM"
                graphPointNumber = 8
            case .month:
                dateComponent = .month
                dateFormat = "MMM"
                graphPointNumber = 8
            @unknown default:
                fatalError("Unknown value: \(period)")
        }
        let selectedDate = dates[timelineIndex]
        let now = Date()
        let currentDate = now.beginning(of: dateComponent)
        let delta = currentDate?.diffWith(date: selectedDate, count: dateComponent)
        if let delta {
            let graphScreenIndex = graphPointNumber - ((-delta) % graphPointNumber) - 1
            let startDate = selectedDate.date(byAdding: -graphScreenIndex, component: dateComponent)
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            var graphDates: [String] = []
            var graphPoints: [GraphPoint?] = []
            for i in 0..<graphPointNumber {
                let date: Date? = startDate?.date(byAdding: i, component: dateComponent)
                let dateString: String
                if let date {
                    dateString = formatter.string(from: date)
                } else {
                    dateString = ""
                }
                graphDates.append(dateString)

                let interpolate = graphItem.graphType == .line
                var point: GraphPoint? = nil
                if let date {
                    if let index = dates.firstIndex(of: date) {
                        if let value = getValue(atIndex: index, for: graphItem, in: timeline) {
                            point = (x: Double(i), y: value, data: PointData(date: sourceDates[index], realPoint: true))
                        } else if interpolate {
                            // Append "invisible point" (by interpolation)
                            var previousValidIndex: Int?
                            var currentIndex = index
                            while previousValidIndex == nil && currentIndex > 0 {
                                currentIndex -= 1
                                if getValue(atIndex: currentIndex, for: graphItem, in: timeline) != nil {
                                    previousValidIndex = currentIndex
                                    break
                                }
                            }
                            var nextValidIndex: Int?
                            currentIndex = index
                            let max = dates.count - 1
                            while nextValidIndex == nil && currentIndex < max {
                                currentIndex += 1
                                if getValue(atIndex: currentIndex, for: graphItem, in: timeline) != nil {
                                    nextValidIndex = currentIndex
                                    break
                                }
                            }
                            if let previousValidIndex, let nextValidIndex {
                                let previousValidDate = dates[previousValidIndex]
                                let nextValidDate = dates[nextValidIndex]
                                if let interpolatedValue = interpolateValueFrom(date: date, previousValidIndex: previousValidIndex, previousValidDate: previousValidDate, nextValidIndex: nextValidIndex, nextValidDate: nextValidDate, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                                    point = (x: Double(i), y: interpolatedValue, data: PointData(date: sourceDates[index], realPoint: false))
                                }
                            }
                        }
                    } else if interpolate {
                        if i == 0 {
                            // Find next valid index
                            var nextValidDate: Date?
                            var index = i
                            let max = dates.count - 1
                            while nextValidDate == nil && index < max {
                                index += 1
                                nextValidDate = startDate?.date(byAdding: index, component: dateComponent)
                            }
                            if let nextValidDate, let nextValidIndex = dates.firstIndex(of: nextValidDate) {
                                let previousValidIndex = nextValidIndex - 1
                                let previousValidDate = dates[previousValidIndex]
                                if let interpolatedValue = interpolateValueFrom(date: date, previousValidIndex: previousValidIndex, previousValidDate: previousValidDate, nextValidIndex: nextValidIndex, nextValidDate: nextValidDate, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                                    point = (x: Double(i), y: interpolatedValue, data: nil)
                                }
                            }
                        } else if i == graphPointNumber - 1 {
                            // Find previous valid index
                            var previousValidDate: Date?
                            var index = i
                            while previousValidDate == nil && index > 0 {
                                index -= 1
                                previousValidDate = startDate?.date(byAdding: index, component: dateComponent)
                            }
                            if let previousValidDate, let previousValidIndex = dates.firstIndex(of: previousValidDate) {
                                let nextValidIndex = previousValidIndex + 1
                                let nextValidDate = dates[nextValidIndex]
                                if let interpolatedValue = interpolateValueFrom(date: date, previousValidIndex: previousValidIndex, previousValidDate: previousValidDate, nextValidIndex: nextValidIndex, nextValidDate: nextValidDate, dateComponent: dateComponent, graphItem: graphItem, timeline: timeline) {
                                    point = (x: Double(i), y: interpolatedValue, data: nil)
                                }
                            }
                        }
                    }
                }
                graphPoints.append(point)
            }
            self.type = graphItem.graphType
            self.points = graphPoints
            self.selectedIndex = graphScreenIndex
            self.xAxisConfig = GraphAxisConfig(min: 0, max: Double(graphPointNumber - 1), labels: graphDates)
            let minYValue = graphItem.graphMinValue
            var labels: [String] = []
            for i in Int(minYValue)...10 {
                labels.append("\(i)")
            }
            self.yAxisConfig = GraphAxisConfig(min: graphItem.graphMinValue, max: 10, labels: labels)
            self.title = graphItem.graphTitle
            self.description = graphItem.getGraphDescription(fromValue: getValue(atIndex: timelineIndex, for: graphItem, in: timeline))
            self.graphViewModelDidUpdate?()
        }
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
                    case .ecoDriving_efficiency:
                        return timeline.allContext.efficiency[index]
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

    private func interpolateValueFrom(date: Date, previousValidIndex: Int, previousValidDate: Date, nextValidIndex: Int, nextValidDate: Date, dateComponent: Calendar.Component, graphItem: GraphItem, timeline: DKTimeline) -> Double? {
        let diffBetweenPreviousAndNext = previousValidDate.diffWith(date: nextValidDate, count: dateComponent)
        let diffBetweenPreviousAndDate = previousValidDate.diffWith(date: date, count: dateComponent)
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
