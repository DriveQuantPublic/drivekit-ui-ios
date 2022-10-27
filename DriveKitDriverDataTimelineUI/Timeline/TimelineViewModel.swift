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

        let timelineSource: DKTimeline?
        switch self.currentPeriod {
            case .week:
                timelineSource = self.weekTimeline
            case .month:
                timelineSource = self.monthTimeline
            @unknown default:
                timelineSource = nil
        }
        if let timelineSource {
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

                self.periodSelectorViewModel.update(selectedPeriod: self.currentPeriod)
                //TODO
                var distanceByContext: [DKRoadContext: Double] = [:]
                for roadContext in timelineSource.roadContexts {
                    let distance = roadContext.distance[selectedDateIndex]
                    distanceByContext[roadContext.type] = distance
                }
                self.roadContextViewModel.configure(distanceByContext: distanceByContext)
            }
        }
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
