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
    
    var timelineDetailViewModel: TimelineDetailViewModel {
        guard let weekTimeline, let monthTimeline else {
            preconditionFailure("Detail button should be disabled until timeline data is available")
        }
        TimelineDetailViewModel(
            selectedScore: selectedScore,
            selectedPeriod: periodSelectorViewModel.selectedPeriod,
            selectedDate: dateSelectorViewModel.selectedDate,
            weekTimeline: weekTimeline,
            monthTimeline: monthTimeline
        )
    }

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
                cleanedTimeline = timelineSource.cleaned(forScore: self.selectedScore, selectedIndex: selectedDateIndex)
            } else {
                cleanedTimeline = timelineSource.cleaned(forScore: self.selectedScore, selectedIndex: nil)
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
                self.roadContextViewModel.configure(
                    with: selectedScore,
                    timeline: cleanedTimeline,
                    selectedIndex: selectedDateIndex
                )
            } else {
                configureWithNoData()
            }
        } else {
            configureWithNoData()
        }
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
            roadContextViewModel.configure(
                with: selectedScore,
                timeline: getTimelineSource()
            )
        }
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
                        date >= compareDate
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
