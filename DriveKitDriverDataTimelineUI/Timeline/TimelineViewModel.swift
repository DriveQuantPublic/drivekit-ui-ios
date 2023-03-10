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
    private var weekTimeline: DKRawTimeline?
    private var monthTimeline: DKRawTimeline?
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
        guard let weekTimeline, let monthTimeline, let selectedDate else {
            preconditionFailure("This method should not be called until timeline data is available (disable the button)")
        }
        let detailVM = TimelineDetailViewModel(
            selectedScore: scoreSelectorViewModel.selectedScore,
            selectedPeriod: periodSelectorViewModel.selectedPeriod,
            selectedDate: selectedDate,
            weekTimeline: weekTimeline,
            monthTimeline: monthTimeline
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

        DriveKitDriverData.shared.getRawTimelines(
            periods: configuredPeriods,
            type: .cache
        ) { [weak self] status, timelines in
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
        DriveKitDriverData.shared.getRawTimelines(
            periods: configuredPeriods,
            type: .defaultSync
        ) { [weak self] status, timelines in
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

    private func update(resettingSelectedDate shouldResetSelectedDate: Bool = false) {
        if let timelineSource = getTimelineSource() {
            if shouldResetSelectedDate {
                self.selectedDate = nil
            }
            // Clean timeline to remove, if needed, values where there are only unscored trips.
            let cleanedTimeline: DKRawTimeline
            if let date = self.selectedDate {
                let selectedDateIndex = timelineSource.allContext.date.selectedIndex(for: date)
                cleanedTimeline = timelineSource.cleaned(forScore: self.scoreSelectorViewModel.selectedScore, selectedIndex: selectedDateIndex)
            } else {
                cleanedTimeline = timelineSource.cleaned(forScore: self.scoreSelectorViewModel.selectedScore, selectedIndex: nil)
            }

            // Update view models.
            if let selectedDateIndex = cleanedTimeline.allContext.date.selectedIndex(for: selectedDate) {
                let dates = cleanedTimeline.allContext.date
                self.selectedDate = dates[selectedDateIndex]
                self.dateSelectorViewModel.configure(dates: dates, period: self.periodSelectorViewModel.selectedPeriod, selectedIndex: selectedDateIndex)
                self.dateSelectorViewModel.delegate = self
                self.timelineGraphViewModel.configure(
                    timeline: cleanedTimeline,
                    timelineSelectedIndex: selectedDateIndex,
                    graphItem: .score(self.scoreSelectorViewModel.selectedScore),
                    period: self.periodSelectorViewModel.selectedPeriod
                )
                self.roadContextViewModel.configure(
                    with: scoreSelectorViewModel.selectedScore,
                    timeline: cleanedTimeline,
                    selectedIndex: selectedDateIndex
                )
                self.shouldHideDetailButton = cleanedTimeline.hasValidTripScored(for: scoreSelectorViewModel.selectedScore, at: selectedDateIndex) == false
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

    private func getTimelineSource() -> DKRawTimeline? {
        getTimelineSource(for: self.periodSelectorViewModel.selectedPeriod)
    }
    
    private func getTimelineSource(for period: DKPeriod) -> DKRawTimeline? {
        let timelineSource: DKRawTimeline?
        switch period {
            case .week:
                timelineSource = self.weekTimeline
            case .month:
                timelineSource = self.monthTimeline
            @unknown default:
                timelineSource = nil
        }
        return timelineSource
    }
    
    private func updateStateAfterSwitching(
        from oldPeriod: DKPeriod,
        to selectedPeriod: DKPeriod
    ) {
        if let selectedDate = self.selectedDate {
            self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
                from: selectedDate,
                in: oldPeriod,
                switchingAmongst: getTimelineSource(for: selectedPeriod)?.allContext.date ?? [],
                in: selectedPeriod
            ) { period, date in
                guard
                    let timeline = getTimelineSource(for: period),
                    let selectedDateIndex = timeline.allContext.date.firstIndex(of: date)
                else {
                    return false
                }
                
                return timeline.hasValidTripScored(
                    for: scoreSelectorViewModel.selectedScore,
                    at: selectedDateIndex
                )
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
