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
    let timelineGraphViewModelByScoreItem: [TimelineScoreItemType: TimelineGraphViewModel]
    
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
    }
}
