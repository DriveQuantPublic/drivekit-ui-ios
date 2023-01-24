//
//  TimelineScoreDetailViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 08/11/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class TimelineDetailViewModel {
    weak var delegate: TimelineDetailViewModelDelegate?
    private let selectedScore: DKScoreType
    private var selectedPeriod: DKTimelinePeriod
    private var selectedDate: Date
    private let weekTimeline: DKTimeline
    private let monthTimeline: DKTimeline
    let periodSelectorViewModel: PeriodSelectorViewModel
    let dateSelectorViewModel: DateSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    private(set) var timelineGraphViewModelByScoreItem: [TimelineScoreItemType: TimelineGraphViewModel]
    
    var localizedTitle: String {
        selectedScore.stringValue()
    }
    
    init(
        selectedScore: DKScoreType,
        selectedPeriod: DKTimelinePeriod,
        selectedDate: Date,
        weekTimeline: DKTimeline,
        monthTimeline: DKTimeline
    ) {
        self.selectedScore = selectedScore
        self.selectedPeriod = selectedPeriod
        self.selectedDate = selectedDate
        self.weekTimeline = weekTimeline
        self.monthTimeline = monthTimeline
        self.periodSelectorViewModel = PeriodSelectorViewModel()
        self.dateSelectorViewModel = DateSelectorViewModel()
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
        let cleanedTimeline: DKTimeline
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
    
    private func getTimelineSource() -> DKTimeline {
        let timelineSource: DKTimeline
        switch self.selectedPeriod {
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

extension TimelineDetailViewModel: PeriodSelectorDelegate {
    func periodSelectorDidSelectPeriod(_ period: DKTimelinePeriod) {
        if self.selectedPeriod != period {
            self.selectedPeriod = period
            self.selectedDate = Helpers.newSelectedDate(
                from: selectedDate,
                switchingTo: period,
                weekTimeline: weekTimeline,
                monthTimeline: monthTimeline
            )
            updateViewModels()
            self.delegate?.didUpdate(selectedPeriod: selectedPeriod)
        }
    }
}

extension TimelineDetailViewModel: DateSelectorDelegate {
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
