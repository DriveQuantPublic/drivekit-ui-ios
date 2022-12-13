//
//  TimelineScoreDetailViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 08/11/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class TimelineDetailViewModel {
    weak var delegate: TimelineViewModelDelegate?
    private let selectedScore: DKTimelineScoreType
    private let selectedPeriod: DKTimelinePeriod
    private let selectedDate: Date
    private let weekTimeline: DKTimeline
    private let monthTimeline: DKTimeline
    let periodSelectorViewModel: PeriodSelectorViewModel
    let dateSelectorViewModel: DateSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    private(set) var timelineGraphViewModelByScoreItem: [TimelineScoreItemType: TimelineGraphViewModel]
    
    init(
        selectedScore: DKTimelineScoreType,
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
        self.configureViewModels()
    }
    
    private func configureViewModels() {
        // Clean timeline to remove, if needed, values where there are only unscored trips.
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
            
            self.dateSelectorViewModel.configure(
                dates: dates,
                period: selectedPeriod,
                selectedIndex: selectedDateIndex
            )
            
            self.roadContextViewModel.configure(
                distanceByContext: cleanedTimeline.distanceByRoadContext(
                    selectedScore: selectedScore,
                    selectedDateIndex: selectedDateIndex),
                totalDistanceForAllContexts: cleanedTimeline.allContext.distance[selectedDateIndex]
            )
            
            let scoreItemTypes = self.selectedScore.associatedScoreItemTypes
            self.timelineGraphViewModelByScoreItem = scoreItemTypes.reduce(into: [:]) { partialResult, scoreItemType in
                let timelineGraphViewModel = TimelineGraphViewModel()
                timelineGraphViewModel.configure(
                    timeline: cleanedTimeline,
                    timelineSelectedIndex: selectedDateIndex,
                    graphItem: .scoreItem(scoreItemType),
                    period: selectedPeriod
                )
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
