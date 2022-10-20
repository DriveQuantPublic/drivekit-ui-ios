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
    let timelineGraphViewModel: TimelineGraphViewModel
    let periodSelectorViewModel: PeriodSelectorViewModel
    let roadContextViewModel: RoadContextViewModel
    var selectedScore: DKTimelineScoreType {
        didSet {
            update()
        }
    }
    private var weekTimeline: DKTimeline?
    private var monthTimeline: DKTimeline?
    private var currentPeriod: DKTimelinePeriod

    init() {
        self.scores = DriveKitDriverDataTimelineUI.shared.scores
        self.selectedScore = self.scores.first ?? .safety

        self.dateSelectorViewModel = DateSelectorViewModel()
        self.timelineGraphViewModel = TimelineGraphViewModel()
        self.periodSelectorViewModel = PeriodSelectorViewModel()
        self.roadContextViewModel = RoadContextViewModel()

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
        self.periodSelectorViewModel.update(selectedPeriod: self.currentPeriod)
    }
}

extension TimelineViewModel: PeriodSelectorDelegate {
    func periodSelectorDidSelectPeriod(_ period: DKTimelinePeriod) {
        self.currentPeriod = period
        update()
    }
}

extension TimelineViewModel: DateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        //TODO
    }
}

extension TimelineViewModel: TimelineGraphDelegate {
    func graphDidSelectDate(_ date: Date) {
        //TODO
    }
}
