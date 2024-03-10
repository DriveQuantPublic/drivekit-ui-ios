//
//  TimelineScoreDetailViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 08/11/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import Foundation

class TimelineDetailViewModel {
    let configuredPeriods: [DKPeriod]
    weak var delegate: TimelineDetailViewModelDelegate?
    private let selectedScore: DKScoreType
    private var selectedPeriod: DKPeriod
    private var selectedDate: Date
    private var timelineByPeriod: [DKPeriod: DKDriverTimeline]
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    private(set) var timelineGraphViewModelByScoreItem: [TimelineScoreItemType: TimelineGraphViewModel]
    
    var localizedTitle: String {
        selectedScore.stringValue()
    }
    
    init(
        configuredPeriods: [DKPeriod],
        selectedScore: DKScoreType,
        selectedPeriod: DKPeriod,
        selectedDate: Date,
        timelineByPeriod: [DKPeriod: DKDriverTimeline]
    ) {
        self.configuredPeriods = configuredPeriods
        self.selectedScore = selectedScore
        self.selectedPeriod = selectedPeriod
        self.selectedDate = selectedDate
        self.timelineByPeriod = timelineByPeriod
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.roadContextViewModel = RoadContextViewModel()
        self.timelineGraphViewModelByScoreItem = [:]
        self.periodSelectorViewModel.configure(
            displayedPeriods: .init(configuredPeriods),
            selectedPeriod: selectedPeriod
        )
        self.updateViewModels()
    }
    
    var orderedScoreItemTypeToDisplay: [TimelineScoreItemType] {
        self.selectedScore.associatedScoreItemTypes
    }
    
    private func updateViewModels() {
        guard let timeline = getTimelineSource() else { return }
        let dates = timeline.allContext.map(\.date)
        if let selectedDateIndex = dates.firstIndex(of: selectedDate) {
            self.periodSelectorViewModel.delegate = self

            self.dateSelectorViewModel.configure(
                dates: dates,
                period: selectedPeriod,
                selectedIndex: selectedDateIndex
            )
            self.dateSelectorViewModel.delegate = self
            
            self.roadContextViewModel.configure(
                with: selectedScore,
                timeline: timeline,
                selectedDate: selectedDate
            )
            
            self.timelineGraphViewModelByScoreItem = self.orderedScoreItemTypeToDisplay.reduce(into: self.timelineGraphViewModelByScoreItem) { partialResult, scoreItemType in
                let timelineGraphViewModel = partialResult[scoreItemType] ?? TimelineGraphViewModel()
                timelineGraphViewModel.configure(
                    timeline: timeline,
                    dates: dates,
                    timelineSelectedIndex: selectedDateIndex,
                    graphItem: .scoreItem(scoreItemType),
                    period: selectedPeriod
                )
                timelineGraphViewModel.delegate = self
                partialResult[scoreItemType] = timelineGraphViewModel
            }
            
        }
    }
    
    private func getTimelineSource() -> DKDriverTimeline? {
        getTimelineSource(for: selectedPeriod)
    }
    
    private func getTimelineSource(for period: DKPeriod) -> DKDriverTimeline? {
        return self.timelineByPeriod[period]
    }
}

extension TimelineDetailViewModel: DKPeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DKPeriod, to newPeriod: DKPeriod) {
        if self.selectedPeriod != newPeriod, let timeline = getTimelineSource(for: newPeriod) {
            self.selectedPeriod = newPeriod
            self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
                from: selectedDate,
                in: oldPeriod,
                switchingAmongst: timeline.allContext.map(\.date),
                in: selectedPeriod
            ) { _, _ in
                return true
            }
            updateViewModels()
            self.delegate?.didUpdate(selectedPeriod: selectedPeriod)
        }
    }
}

extension TimelineDetailViewModel: DKDateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        selectedDate = date
        updateViewModels()
        self.delegate?.didUpdate(selectedDate: selectedDate)
    }
}

extension TimelineDetailViewModel: TimelineGraphDelegate {
    func graphDidSelectDate(_ date: Date) {
        self.selectedDate = date
        updateViewModels()
        self.delegate?.didUpdate(selectedDate: selectedDate)
    }
}
