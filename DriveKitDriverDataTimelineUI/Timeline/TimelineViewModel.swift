//
//  TimelineViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import Foundation

class TimelineViewModel {
    let configuredPeriods: [DKPeriod] = [.week, .month]
    private(set) var updating: Bool = false
    weak var delegate: TimelineViewModelDelegate?
    let scoreSelectorViewModel: DKScoreSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    let timelineGraphViewModel: TimelineGraphViewModel
    private var timelineByPeriod: [DKPeriod: DKDriverTimeline] = [:]
    private var selectedDate: Date?
    
    private(set) var shouldHideDetailButton: Bool = true {
        didSet {
            self.delegate?.didUpdateDetailButtonDisplay()
        }
    }
    
    var timelineDetailButtonTitle: String {
        "dk_timeline_button_timeline_detail".dkDriverDataTimelineLocalized()
    }
    
    var timelineDetailViewModel: TimelineDetailViewModel {
        guard !timelineByPeriod.isEmpty, let selectedDate else {
            preconditionFailure("This method should not be called until timeline data is available (disable the button)")
        }
        let detailVM = TimelineDetailViewModel(
            configuredPeriods: configuredPeriods,
            selectedScore: scoreSelectorViewModel.selectedScore,
            selectedPeriod: periodSelectorViewModel.selectedPeriod,
            selectedDate: selectedDate,
            timelineByPeriod: timelineByPeriod
        )
        detailVM.delegate = self
        return detailVM
    }

    init() {
        self.scoreSelectorViewModel = DKScoreSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.roadContextViewModel = RoadContextViewModel()
        self.timelineGraphViewModel = TimelineGraphViewModel()

        self.scoreSelectorViewModel.delegate = self
        self.periodSelectorViewModel.delegate = self
        self.timelineGraphViewModel.delegate = self
        
        self.periodSelectorViewModel.configure(
            displayedPeriods: .init(configuredPeriods),
            selectedPeriod: .week
        )

        DriveKitDriverData.shared.getDriverTimelines(periods: configuredPeriods, ignoreItemsWithoutTripScored: true, type: .cache) { [weak self] status, timelines in
            if let self {
                if status == .cacheDataOnly, let timelines {
                    self.timelineByPeriod = timelines.reduce(into: [DKPeriod: DKDriverTimeline]()) { partialResult, timeline in
                        partialResult[timeline.period] = timeline
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
        DriveKitDriverData.shared.getDriverTimelines(periods: configuredPeriods, ignoreItemsWithoutTripScored: true, type: .defaultSync) { [weak self] status, timelines in
            if let self {
                if status != .noTimelineYet, let timelines {
                    self.timelineByPeriod = timelines.reduce(into: [DKPeriod: DKDriverTimeline]()) { partialResult, timeline in
                        partialResult[timeline.period] = timeline
                    }
                    self.update(resettingSelectedDate: true)
                }
                self.updating = false
                self.delegate?.didUpdateTimeline()
            }
        }
    }

    private func update(resettingSelectedDate shouldResetSelectedDate: Bool = false) {
        if let timeline = getTimelineSource() {
            if shouldResetSelectedDate {
                self.selectedDate = nil
            }
            // Update view models.
            let selectedAllContextItem: DKDriverTimeline.DKAllContextItem?
            let selectedDateIndex: Int?
            if let selectedDate {
                let result = timeline.allContext.enumerated().first { (_, allContextItem) in
                    allContextItem.date == selectedDate
                }
                selectedAllContextItem = result?.element
                selectedDateIndex = result?.offset
            } else {
                selectedAllContextItem = timeline.allContext.last
                selectedDateIndex = timeline.allContext.isEmpty ? nil : timeline.allContext.count - 1
            }
            if let allContextItem = selectedAllContextItem, let selectedDateIndex {
                self.selectedDate = allContextItem.date
                let dates = timeline.allContext.map(\.date)
                self.dateSelectorViewModel.configure(dates: dates, period: self.periodSelectorViewModel.selectedPeriod, selectedIndex: selectedDateIndex)
                self.dateSelectorViewModel.delegate = self
                self.timelineGraphViewModel.configure(
                    timeline: timeline,
                    dates: dates,
                    timelineSelectedIndex: selectedDateIndex,
                    graphItem: .score(self.scoreSelectorViewModel.selectedScore),
                    period: self.periodSelectorViewModel.selectedPeriod
                )
                self.roadContextViewModel.configure(
                    with: scoreSelectorViewModel.selectedScore,
                    timeline: timeline,
                    selectedDate: self.selectedDate
                )
                self.shouldHideDetailButton = false
            } else {
                configureWithNoData()
            }
        } else {
            configureWithNoData()
        }
    }

    private func configureWithNoData() {
        let startDate: Date?
        switch self.periodSelectorViewModel.selectedPeriod {
            case .week:
                startDate = Date().beginning(relativeTo: .weekOfMonth)
            case .month:
                startDate = Date().beginning(relativeTo: .month)
            case .year:
                fallthrough
            @unknown default:
                startDate = nil
        }
        if let startDate {
            self.dateSelectorViewModel.configure(
                dates: [startDate],
                period: self.periodSelectorViewModel.selectedPeriod,
                selectedIndex: 0
            )
            self.timelineGraphViewModel.showEmptyGraph(
                graphItem: .score(self.scoreSelectorViewModel.selectedScore),
                period: self.periodSelectorViewModel.selectedPeriod
            )
            roadContextViewModel.configure(
                with: scoreSelectorViewModel.selectedScore,
                timeline: getTimelineSource()
            )
        }
        self.shouldHideDetailButton = true
    }

    private func getTimelineSource() -> DKDriverTimeline? {
        getTimelineSource(for: self.periodSelectorViewModel.selectedPeriod)
    }
    
    private func getTimelineSource(for period: DKPeriod) -> DKDriverTimeline? {
        return self.timelineByPeriod[period]
    }
    
    private func updateStateAfterSwitching(
        from oldPeriod: DKPeriod,
        to selectedPeriod: DKPeriod
    ) {
        if let selectedDate = self.selectedDate {
            self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
                from: selectedDate,
                in: oldPeriod,
                switchingAmongst: getTimelineSource(for: selectedPeriod)?.allContext.map(\.date) ?? [],
                in: selectedPeriod
            ) { period, _ in
                return getTimelineSource(for: period) != nil
            }
        }
        update()
    }
}

extension TimelineViewModel: DKPeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DriveKitCoreModule.DKPeriod, to newPeriod: DriveKitCoreModule.DKPeriod) {
        updateStateAfterSwitching(from: oldPeriod, to: newPeriod)
    }
}

extension TimelineViewModel: DKDateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        self.selectedDate = date
        update()
    }
}

extension TimelineViewModel: DKScoreSelectorDelegate {
    func scoreSelectorDidSelectScore(_ score: DKScoreType) {
        update()
    }
}

extension TimelineViewModel: TimelineGraphDelegate {
    func graphDidSelectDate(_ date: Date) {
        self.selectedDate = date
        update()
    }
}

extension TimelineViewModel: TimelineDetailViewModelDelegate {
    func didUpdate(selectedDate: Date) {
        self.selectedDate = selectedDate
        update()
    }
    
    func didUpdate(selectedPeriod: DKPeriod) {
        if self.periodSelectorViewModel.selectedPeriod != selectedPeriod {
            let oldPeriod = self.periodSelectorViewModel.selectedPeriod
            self.periodSelectorViewModel.configure(
                displayedPeriods: self.periodSelectorViewModel.displayedPeriods,
                selectedPeriod: selectedPeriod
            )
            updateStateAfterSwitching(from: oldPeriod, to: selectedPeriod)
        }
    }
}
