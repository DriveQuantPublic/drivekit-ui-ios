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
                    self.selectedDate = nil
                    self.update()
                }
                self.updating = false
                self.delegate?.didUpdateTimeline()
            }
        }
    }

    private func update() {
        print("===== update =====")
        print("= selectedScore = \(self.selectedScore)")
        print("= currentPeriod = \(self.currentPeriod)")

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
                print("= dates = \(dates)")
                print("= selectedDateIndex = \(selectedDateIndex)")

                self.dateSelectorViewModel.update(dates: dates, period: self.currentPeriod, selectedIndex: selectedDateIndex)
                self.periodSelectorViewModel.update(selectedPeriod: self.currentPeriod)
                self.timelineGraphViewModel.configure(timeline: timelineSource, timelineIndex: selectedDateIndex, graphItem: .score(self.selectedScore), period: self.currentPeriod)
                //TODO
                var distanceByContext: [TimelineRoadContext: Double] = [:]
                for roadContext in timelineSource.roadContexts {
                    if let timelineRoadContext = TimelineRoadContext(roadContext: roadContext.type) {
                        let distance = roadContext.distance[selectedDateIndex]
                        distanceByContext[timelineRoadContext] = distance
                    }
                }
                self.roadContextViewModel.configure(distanceByContext: distanceByContext)
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
