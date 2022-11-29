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

                if let date, let index = dates.firstIndex(of: date) {
                    let value = getValue(atIndex: index, for: graphItem, in: timeline)
                    graphPoints.append((x: Double(i), y: value, data: sourceDates[index]))
                } else {
                    graphPoints.append(nil)
                }
            }
            print("= graphDates = \(graphDates)")
            print("= graphScreenIndex = \(graphScreenIndex)")
            print("= graphPoints = \(graphPoints)")

            self.type = graphItem.getGraphType()
            self.points = graphPoints
            self.selectedIndex = graphScreenIndex
            self.xAxisConfig = GraphAxisConfig(min: 0, max: Double(graphPointNumber - 1), labels: graphDates)
            self.yAxisConfig = GraphAxisConfig(min: 0, max: 10, labels: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
            self.title = "Test title - \(self.type)"
            self.description = "Test description"
            self.graphViewModelDidUpdate?()
        }
    }

    private func getValue(atIndex index: Int, for graphItem: GraphItem, in timeline: DKTimeline) -> Double {
        switch graphItem {
            case .score(let scoreType):
                switch scoreType {
                    case .safety:
                        return timeline.allContext.safety[index]
                    case .distraction:
                        return timeline.allContext.phoneDistraction[index]
                    case .ecoDriving:
                        return timeline.allContext.efficiency[index]
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
                    case .distraction_unlock:
                        return Double(timeline.allContext.unlock[index])
                    case .distraction_numberTripWithForbiddenCall:
                        return Double(timeline.allContext.numberTripWithForbiddenCall[index])
                    case .distraction_forbiddenCall:
                        return Double(timeline.allContext.callForbidden[index])
                }
        }
    }
}

extension TimelineGraphViewModel: GraphViewDelegate {
    func graphDidSelectPoint(_ point: GraphPoint) {
        if let data = point.data, let date = data as? Date {
            self.delegate?.graphDidSelectDate(date)
        }
    }
}
