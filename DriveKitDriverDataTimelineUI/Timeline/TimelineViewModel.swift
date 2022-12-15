//
//  TimelineViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

class TimelineViewModel {
    private(set) var updating: Bool = false
    weak var delegate: TimelineViewModelDelegate?
    let scores: [DKTimelineScoreType]
    let dateSelectorViewModel: DateSelectorViewModel
    let periodSelectorViewModel: PeriodSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    let timelineGraphViewModel: TimelineGraphViewModel
    var selectedScore: DKTimelineScoreType {
        didSet {
            update()
        }
    }
    var hasData: Bool {
        if let timelineSource = getTimelineSource() {
            return !timelineSource.allContext.numberTripTotal.isEmpty
        } else {
            return false
        }
    }
    private var weekTimeline: DKTimeline?
    private var monthTimeline: DKTimeline?
    private var currentPeriod: DKTimelinePeriod
    private var selectedDate: Date?

    init() {
        self.scores = DriveKitDriverDataTimelineUI.shared.scores
        self.selectedScore = self.scores.first ?? .safety

        self.dateSelectorViewModel = DateSelectorViewModel()
        self.periodSelectorViewModel = PeriodSelectorViewModel()
        self.roadContextViewModel = RoadContextViewModel()
        self.timelineGraphViewModel = TimelineGraphViewModel()
        self.currentPeriod = self.periodSelectorViewModel.selectedPeriod

        self.periodSelectorViewModel.delegate = self
        self.timelineGraphViewModel.delegate = self

        DriveKitDriverData.shared.getTimelines(periods: [.week, .month], type: .cache) { [weak self] status, timelines in
            if let self {
                if status == .cacheDataOnly, let timelines {
                    for timeline in timelines {
                        switch timeline.period {
                            case .month:
                                self.monthTimeline = timeline
                            case .week:
                                self.weekTimeline = timeline
                            @unknown default:
                                break
                        }
                    }
                    self.update()
                }
            }
        }
        updateTimeline()
    }

    func updateTimeline() {
        self.updating = true
        self.delegate?.willUpdateTimeline()
        DriveKitDriverData.shared.getTimelines(periods: [.week, .month], type: .defaultSync) { [weak self] status, timelines in
            if let self {
                if status != .noTimelineYet, let timelines {
                    for timeline in timelines {
                        switch timeline.period {
                            case .month:
                                self.monthTimeline = timeline
                            case .week:
                                self.weekTimeline = timeline
                            @unknown default:
                                break
                        }
                    }
                    self.update(resettingSelectedDate: true)
                }
                self.updating = false
                self.delegate?.didUpdateTimeline()
            }
        }
    }

    func showPreviousGraphData() {
        self.timelineGraphViewModel.showPreviousGraphData()
    }

    func showNextGraphData() {
        self.timelineGraphViewModel.showNextGraphData()
    }

    private func update(resettingSelectedDate shouldResetSelectedDate: Bool = false) {
        if let timelineSource = getTimelineSource() {
            if shouldResetSelectedDate {
                self.selectedDate = nil
            }
            // Clean timeline to remove, if needed, values where there are only unscored trips.
            let sourceDates = timelineSource.allContext.date
            let cleanedTimeline: DKTimeline
            if let date = self.selectedDate {
                let selectedDateIndex = sourceDates.firstIndex(of: date)
                cleanedTimeline = cleanTimeline(timelineSource, forScore: self.selectedScore, selectedIndex: selectedDateIndex)
            } else {
                cleanedTimeline = cleanTimeline(timelineSource, forScore: self.selectedScore, selectedIndex: nil)
            }
            // Compute selected index.
            let dates = cleanedTimeline.allContext.date
            let selectedDateIndex: Int?
            if let date = self.selectedDate {
                selectedDateIndex = dates.firstIndex(of: date)
            } else if !dates.isEmpty {
                selectedDateIndex = dates.count - 1
            } else {
                selectedDateIndex = nil
            }
            // Update view models.
            if let selectedDateIndex {
                self.selectedDate = dates[selectedDateIndex]
                self.dateSelectorViewModel.configure(dates: dates, period: self.currentPeriod, selectedIndex: selectedDateIndex)
                self.periodSelectorViewModel.configure(selectedPeriod: self.currentPeriod)
                self.timelineGraphViewModel.configure(timeline: cleanedTimeline, timelineSelectedIndex: selectedDateIndex, graphItem: .score(self.selectedScore), period: self.currentPeriod)
                updateRoadContextViewModel(timeline: cleanedTimeline, selectedIndex: selectedDateIndex)
            } else {
                configureWithNoData()
            }
        } else {
            configureWithNoData()
        }
        self.delegate?.needToBeRefreshed()
    }

    private func configureWithNoData() {
        let startDate: Date?
        switch self.currentPeriod {
            case .week:
                startDate = Date().beginning(relativeTo: .weekOfMonth)
            case .month:
                startDate = Date().beginning(relativeTo: .month)
            @unknown default:
                startDate = nil
        }
        if let startDate {
            self.dateSelectorViewModel.configure(dates: [startDate], period: self.currentPeriod, selectedIndex: 0)
            self.timelineGraphViewModel.showEmptyGraph(graphItem: .score(self.selectedScore), period: self.currentPeriod)
            updateRoadContextViewModel(timeline: getTimelineSource(), selectedIndex: nil)
        }
    }

    private func updateRoadContextViewModel(timeline: DKTimeline?, selectedIndex: Int?) {
        let totalDistanceForAllContexts: Double
        var distanceByContext: [TimelineRoadContext: Double] = [:]
        if let timeline, let selectedIndex, self.selectedScore == .distraction || self.selectedScore == .speeding || timeline.allContext.numberTripScored[selectedIndex] > 0 {
            totalDistanceForAllContexts = timeline.allContext.distance[selectedIndex]
            for roadContext in timeline.roadContexts {
                if let timelineRoadContext = TimelineRoadContext(roadContext: roadContext.type) {
                    let distance = roadContext.distance[selectedIndex]
                    distanceByContext[timelineRoadContext] = distance
                }
            }
        } else {
            totalDistanceForAllContexts = 0
        }
        self.roadContextViewModel.configure(
            with: .data(
                distanceByContext: distanceByContext,
                totalDistanceForAllContexts: totalDistanceForAllContexts
            )
        )
    }

    private func getTimelineSource() -> DKTimeline? {
        let timelineSource: DKTimeline?
        switch self.currentPeriod {
            case .week:
                timelineSource = self.weekTimeline
            case .month:
                timelineSource = self.monthTimeline
            @unknown default:
                timelineSource = nil
        }
        return timelineSource
    }

    private func cleanTimeline(_ timeline: DKTimeline, forScore score: DKTimelineScoreType, selectedIndex: Int?) -> DKTimeline {
        let canInsertAtIndex: (Int) -> Bool = { index in
            timeline.allContext.numberTripScored[index] > 0 || score == .distraction || score == .speeding || index == selectedIndex
        }
        var date: [Date] = []
        var numberTripTotal: [Int] = []
        var numberTripScored: [Int] = []
        var distance: [Double] = []
        var duration: [Int] = []
        var efficiency: [Double] = []
        var safety: [Double] = []
        var acceleration: [Int] = []
        var braking: [Int] = []
        var adherence: [Int] = []
        var phoneDistraction: [Double] = []
        var speeding: [Double] = []
        var co2Mass: [Double] = []
        var fuelVolume: [Double] = []
        var unlock: [Int] = []
        var lock: [Int] = []
        var callAuthorized: [Int] = []
        var callForbidden: [Int] = []
        var callForbiddenDuration: [Int] = []
        var callAuthorizedDuration: [Int] = []
        var numberTripWithForbiddenCall: [Int] = []
        var speedingDuration: [Int] = []
        var speedingDistance: [Double] = []
        var efficiencyBrake: [Double] = []
        var efficiencyAcceleration: [Double] = []
        var efficiencySpeedMaintain: [Double] = []
        let maxItems = timeline.allContext.date.count
        for index in 0..<maxItems {
            if canInsertAtIndex(index) {
                date.append(timeline.allContext.date[index])
                numberTripTotal.append(timeline.allContext.numberTripTotal[index])
                numberTripScored.append(timeline.allContext.numberTripScored[index])
                distance.append(timeline.allContext.distance[index])
                duration.append(timeline.allContext.duration[index])
                efficiency.append(timeline.allContext.efficiency[index])
                safety.append(timeline.allContext.safety[index])
                acceleration.append(timeline.allContext.acceleration[index])
                braking.append(timeline.allContext.braking[index])
                adherence.append(timeline.allContext.adherence[index])
                phoneDistraction.append(timeline.allContext.phoneDistraction[index])
                speeding.append(timeline.allContext.speeding[index])
                co2Mass.append(timeline.allContext.co2Mass[index])
                fuelVolume.append(timeline.allContext.fuelVolume[index])
                unlock.append(timeline.allContext.unlock[index])
                lock.append(timeline.allContext.lock[index])
                callAuthorized.append(timeline.allContext.callAuthorized[index])
                callForbidden.append(timeline.allContext.callForbidden[index])
                callForbiddenDuration.append(timeline.allContext.callForbiddenDuration[index])
                callAuthorizedDuration.append(timeline.allContext.callAuthorizedDuration[index])
                if !timeline.allContext.numberTripWithForbiddenCall.isEmpty {
                    numberTripWithForbiddenCall.append(timeline.allContext.numberTripWithForbiddenCall[index])
                    speedingDuration.append(timeline.allContext.speedingDuration[index])
                    speedingDistance.append(timeline.allContext.speedingDistance[index])
                    efficiencyBrake.append(timeline.allContext.efficiencyBrake[index])
                    efficiencyAcceleration.append(timeline.allContext.efficiencyAcceleration[index])
                    efficiencySpeedMaintain.append(timeline.allContext.efficiencySpeedMaintain[index])
                }
            }
        }

        var roadContexts: [DKTimeline.RoadContextItem] = []
        for roadContext in timeline.roadContexts {
            var date: [Date] = []
            var numberTripTotal: [Int] = []
            var numberTripScored: [Int] = []
            var distance: [Double] = []
            var duration: [Int] = []
            var efficiency: [Double] = []
            var safety: [Double] = []
            var acceleration: [Int] = []
            var braking: [Int] = []
            var adherence: [Int] = []
            var co2Mass: [Double] = []
            var fuelVolume: [Double] = []
            var efficiencyAcceleration: [Double] = []
            var efficiencyBrake: [Double] = []
            var efficiencySpeedMaintain: [Double] = []
            for index in 0..<maxItems {
                if canInsertAtIndex(index) {
                    date.append(roadContext.date[index])
                    numberTripTotal.append(roadContext.numberTripTotal[index])
                    numberTripScored.append(roadContext.numberTripScored[index])
                    distance.append(roadContext.distance[index])
                    duration.append(roadContext.duration[index])
                    efficiency.append(roadContext.efficiency[index])
                    safety.append(roadContext.safety[index])
                    acceleration.append(roadContext.acceleration[index])
                    braking.append(roadContext.braking[index])
                    adherence.append(roadContext.adherence[index])
                    co2Mass.append(roadContext.co2Mass[index])
                    fuelVolume.append(roadContext.fuelVolume[index])
                    if !roadContext.efficiencyAcceleration.isEmpty {
                        efficiencyAcceleration.append(roadContext.efficiencyAcceleration[index])
                        efficiencyBrake.append(roadContext.efficiencyBrake[index])
                        efficiencySpeedMaintain.append(roadContext.efficiencySpeedMaintain[index])
                    }
                }
            }
            let newRoadContext = DKTimeline.RoadContextItem(type: roadContext.type, date: date, numberTripTotal: numberTripTotal, numberTripScored: numberTripScored, distance: distance, duration: duration, efficiency: efficiency, safety: safety, acceleration: acceleration, braking: braking, adherence: adherence, co2Mass: co2Mass, fuelVolume: fuelVolume, efficiencyAcceleration: efficiencyAcceleration, efficiencyBrake: efficiencyBrake, efficiencySpeedMaintain: efficiencySpeedMaintain)
            roadContexts.append(newRoadContext)
        }

        let allContext: DKTimeline.AllContextItem = DKTimeline.AllContextItem(date: date, numberTripTotal: numberTripTotal, numberTripScored: numberTripScored, distance: distance, duration: duration, efficiency: efficiency, safety: safety, acceleration: acceleration, braking: braking, adherence: adherence, phoneDistraction: phoneDistraction, speeding: speeding, co2Mass: co2Mass, fuelVolume: fuelVolume, unlock: unlock, lock: lock, callAuthorized: callAuthorized, callForbidden: callForbidden, callAuthorizedDuration: callAuthorizedDuration, callForbiddenDuration: callForbiddenDuration, numberTripWithForbiddenCall: numberTripWithForbiddenCall, speedingDuration: speedingDuration, speedingDistance: speedingDistance, efficiencyBrake: efficiencyBrake, efficiencyAcceleration: efficiencyAcceleration, efficiencySpeedMaintain: efficiencySpeedMaintain)
        let cleanedTimeline = DKTimeline(period: timeline.period, allContext: allContext, roadContexts: roadContexts)
        return cleanedTimeline
    }
}

extension TimelineViewModel: PeriodSelectorDelegate {
    func periodSelectorDidSelectPeriod(_ period: DKTimelinePeriod) {
        if self.currentPeriod != period {
            self.currentPeriod = period
            if let selectedDate = self.selectedDate, let timeline = getTimelineSource() {
                let dates = timeline.allContext.date
                let compareDate: Date?
                if period == .week {
                    // Changed from .month to .week
                    compareDate = selectedDate
                } else {
                    // Changed from .week to .month
                    compareDate = DriveKitDriverDataTimelineUI.calendar.date(from: DriveKitDriverDataTimelineUI.calendar.dateComponents([.year, .month], from: selectedDate))
                }
                if let compareDate {
                    let newDate = dates.first { date in
                        date > compareDate
                    }
                    self.selectedDate = newDate
                }
            }
            update()
        }
    }
}

extension TimelineViewModel: DateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        self.selectedDate = date
        update()
    }
}

extension TimelineViewModel: TimelineGraphDelegate {
    func graphDidSelectDate(_ date: Date) {
        self.selectedDate = date
        update()
    }
}
