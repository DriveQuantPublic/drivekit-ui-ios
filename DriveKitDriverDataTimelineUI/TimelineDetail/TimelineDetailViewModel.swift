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
    weak var delegate: TimelineDetailViewModelDelegate?
    private let selectedScore: DKScoreType
    private var selectedPeriod: DKPeriod
    private var selectedDate: Date
    private let weekTimeline: DKRawTimeline
    private let monthTimeline: DKRawTimeline
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    private(set) var timelineGraphViewModelByScoreItem: [TimelineScoreItemType: TimelineGraphViewModel]
    
    var localizedTitle: String {
        selectedScore.stringValue()
    }
    
    init(
        selectedScore: DKScoreType,
        selectedPeriod: DKPeriod,
        selectedDate: Date,
        weekTimeline: DKRawTimeline,
        monthTimeline: DKRawTimeline
    ) {
        self.selectedScore = selectedScore
        self.selectedPeriod = selectedPeriod
        self.selectedDate = selectedDate
        self.weekTimeline = weekTimeline
        self.monthTimeline = monthTimeline
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.roadContextViewModel = RoadContextViewModel()
        self.timelineGraphViewModelByScoreItem = [:]
        self.updateViewModels()
    }
    
    var orderedScoreItemTypeToDisplay: [TimelineScoreItemType] {
        self.selectedScore.associatedScoreItemTypes
    }
    
    private func updateViewModels() {
        let selectedTimeline = getTimelineSource()
        let sourceDates = selectedTimeline.allContext.date
        let cleanedTimeline: DKRawTimeline
        var selectedDateIndex = sourceDates.firstIndex(of: selectedDate)
        cleanedTimeline = selectedTimeline.cleaned(
            forScore: self.selectedScore,
            selectedIndex: selectedDateIndex
        )

        // Compute selected index.
        let dates = cleanedTimeline.allContext.date
        selectedDateIndex = dates.firstIndex(of: selectedDate)
        
        // Update view models.
        if let selectedDateIndex {
            self.periodSelectorViewModel.configure(
                displayedPeriods: [.week, .month],
                selectedPeriod: selectedPeriod
            )
            self.periodSelectorViewModel.delegate = self

            self.dateSelectorViewModel.configure(
                dates: dates,
                period: selectedPeriod,
                selectedIndex: selectedDateIndex
            )
            self.dateSelectorViewModel.delegate = self
            
            self.roadContextViewModel.configure(
                with: selectedScore,
                timeline: cleanedTimeline,
                selectedIndex: selectedDateIndex
            )
            
            self.timelineGraphViewModelByScoreItem = self.orderedScoreItemTypeToDisplay.reduce(into: self.timelineGraphViewModelByScoreItem) { partialResult, scoreItemType in
                let timelineGraphViewModel = partialResult[scoreItemType] ?? TimelineGraphViewModel()
                timelineGraphViewModel.configure(
                    timeline: cleanedTimeline,
                    timelineSelectedIndex: selectedDateIndex,
                    graphItem: .scoreItem(scoreItemType),
                    period: selectedPeriod
                )
                timelineGraphViewModel.delegate = self
                partialResult[scoreItemType] = timelineGraphViewModel
            }
            
        }
    }
    
    private func getTimelineSource() -> DKRawTimeline {
        getTimelineSource(for: selectedPeriod)
    }
    
    private func getTimelineSource(for period: DKPeriod) -> DKRawTimeline {
        let timelineSource: DKRawTimeline
        switch period {
            case .week:
                timelineSource = self.weekTimeline
            case .month:
                timelineSource = self.monthTimeline
            @unknown default:
                preconditionFailure("period \(self.selectedPeriod) is not implemented yet")
        }
        return timelineSource
    }
}

extension TimelineDetailViewModel: DKPeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DKPeriod, to newPeriod: DKPeriod) {
        if self.selectedPeriod != newPeriod {
            self.selectedPeriod = newPeriod
            self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
                from: selectedDate,
                in: getTimelineSource(for: oldPeriod).periodDates,
                switchingTo: getTimelineSource(for: newPeriod).periodDates
            )
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
