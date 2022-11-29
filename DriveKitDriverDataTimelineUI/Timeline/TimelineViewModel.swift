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
                                self.monthTimeline = self.cleanTimeline(timeline)
                            case .week:
                                self.weekTimeline = self.cleanTimeline(timeline)
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
                                self.monthTimeline = self.cleanTimeline(timeline)
                            case .week:
                                self.weekTimeline = self.cleanTimeline(timeline)
                            @unknown default:
                                break
                        }
                    }
                    self.selectedDate = nil
                    self.update()
                }
                self.updating = false
                self.delegate?.didUpdateTimeline()
            }
        }
    }

    private func update() {
        if let timelineSource = getTimelineSource() {
            let dates = timelineSource.allContext.date

            let selectedDateIndex: Int?
            if let date = self.selectedDate {
                selectedDateIndex = dates.firstIndex(of: date)
            } else if !dates.isEmpty {
                selectedDateIndex = dates.count - 1
            } else {
                selectedDateIndex = nil
            }
            if let selectedDateIndex {
                self.dateSelectorViewModel.update(dates: dates, period: self.currentPeriod, selectedIndex: selectedDateIndex)
                self.periodSelectorViewModel.update(selectedPeriod: self.currentPeriod)
                self.timelineGraphViewModel.configure(timeline: timelineSource, timelineIndex: selectedDateIndex, graphItem: .score(self.selectedScore), period: self.currentPeriod)
                var distanceByContext: [TimelineRoadContext: Double] = [:]
                for roadContext in timelineSource.roadContexts {
                    if let timelineRoadContext = TimelineRoadContext(roadContext: roadContext.type) {
                        let distance = roadContext.distance[selectedDateIndex]
                        distanceByContext[timelineRoadContext] = distance
                    }
                }
                self.roadContextViewModel.configure(distanceByContext: distanceByContext, totalDistance: timelineSource.allContext.distance[selectedDateIndex])
            }
        }
        self.delegate?.needToBeRefreshed()
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

    private func cleanTimeline(_ timeline: DKTimeline) -> DKTimeline {
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
            if timeline.allContext.numberTripScored[index] > 0 {
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
                numberTripWithForbiddenCall.append(timeline.allContext.numberTripWithForbiddenCall[index])
                speedingDuration.append(timeline.allContext.speedingDuration[index])
                speedingDistance.append(timeline.allContext.speedingDistance[index])
                efficiencyBrake.append(timeline.allContext.efficiencyBrake[index])
                efficiencyAcceleration.append(timeline.allContext.efficiencyAcceleration[index])
                efficiencySpeedMaintain.append(timeline.allContext.efficiencySpeedMaintain[index])
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
                if timeline.allContext.numberTripScored[index] > 0 {
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
                    efficiencyAcceleration.append(roadContext.efficiencyAcceleration[index])
                    efficiencyBrake.append(roadContext.efficiencyBrake[index])
                    efficiencySpeedMaintain.append(roadContext.efficiencySpeedMaintain[index])
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
