//
//  MySynthesisViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 20/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import Foundation

class MySynthesisViewModel {
    let configuredPeriods: [DKPeriod] = [.week, .month, .year]
    weak var delegate: MySynthesisViewModelDelegate?
    let scoreSelectorViewModel: DKScoreSelectorViewModel
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    let scoreCardViewModel: MySynthesisScoreCardViewModel
    let communityCardViewModel: MySynthesisCommunityCardViewModel
    private var timelines: [DKPeriod: DKDriverTimeline]
    private var communityStatistics: DKCommunityStatistics?
    private var selectedDate: Date?
    private(set) var updating: Bool = false
    
    var shouldHideDetailButton: Bool {
        return true
    }
    
    init() {
        self.scoreSelectorViewModel = DKScoreSelectorViewModel()
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.scoreCardViewModel = MySynthesisScoreCardViewModel()
        self.communityCardViewModel = MySynthesisCommunityCardViewModel()
        self.timelines = [:]
        self.selectedDate = nil

        self.scoreSelectorViewModel.delegate = self
        self.periodSelectorViewModel.delegate = self
        self.dateSelectorViewModel.delegate = self
        
        self.periodSelectorViewModel.configure(
            displayedPeriods: .init(configuredPeriods),
            selectedPeriod: .year
        )
        
        DriveKitDriverData.shared.getDriverTimelines(
            periods: self.configuredPeriods,
            type: .cache
        ) { [weak self] status, timelines in
            guard let self else { return }
            if status == .cacheDataOnly, let timelines {
                self.timelines = timelines.reduce(into: [:]) { resultSoFar, timeline in
                    resultSoFar[timeline.period] = timeline
                }
            }
            
            DriveKitDriverData.shared.getCommunityStatistics(
                type: .cache
            ) { [weak self] status, statistics in
                guard let self else { return }
                if status == .cacheDataOnly, let statistics {
                    self.communityStatistics = statistics
                }
                self.update()
            }
        }
        updateData()
    }
    
    func updateData() {
        self.updating = true
        self.delegate?.willUpdateData()
        DriveKitDriverData.shared.getDriverTimelines(
            periods: configuredPeriods,
            type: .defaultSync
        ) { [weak self] status, timelines in
            guard let self else { return }
            if status != .noTimelineYet, let timelines {
                self.timelines = timelines.reduce(into: [:]) { resultSoFar, timeline in
                    resultSoFar[timeline.period] = timeline
                }
                self.update(resettingSelectedDate: true)
            }
            
            DriveKitDriverData.shared.getCommunityStatistics(
                type: .defaultSync
            ) { [weak self] status, statistics in
                guard let self else { return }
                if status == .success, let statistics {
                    self.communityStatistics = statistics
                }
                self.updating = false
                self.update(resettingSelectedDate: false)
                self.delegate?.didUpdateData()
            }
        }
    }
    
    private func update(resettingSelectedDate: Bool = false) {
        guard let currentTimeline = timelines[self.periodSelectorViewModel.selectedPeriod] else {
            configureWithNoData()
            return
        }
        
        if resettingSelectedDate {
            self.selectedDate = nil
        }
        
        self.periodSelectorViewModel.configure(
            displayedPeriods: .init(configuredPeriods),
            selectedPeriod: currentTimeline.period
        )

        let allDates = currentTimeline.allContext.filter { item in
            switch self.scoreSelectorViewModel.selectedScore {
                case .safety:
                    return item.safety != nil
                case .ecoDriving:
                    return item.ecoDriving != nil
                case .distraction, .speeding:
                    return true
            }
        }.map(\.date)

        let selectedDateIndex = allDates.selectedIndex(for: selectedDate)
        self.dateSelectorViewModel.configure(
            dates: allDates,
            period: currentTimeline.period,
            selectedIndex: selectedDateIndex
        )

        self.selectedDate = self.dateSelectorViewModel.selectedDate
        if
            let selectedDate,
            let scoreSynthesis = currentTimeline.driverScoreSynthesis(
                for: scoreSelectorViewModel.selectedScore,
                at: dateSelectorViewModel.selectedDate
        ) {
            let previousPeriodContext = currentTimeline.allContext.previousValidItem(
                from: selectedDate,
                scoreType: scoreSynthesis.scoreType
            )
            let currentPeriodContext = currentTimeline.allContext[date: selectedDate]
            self.scoreCardViewModel.configure(
                with: scoreSynthesis,
                period: periodSelectorViewModel.selectedPeriod,
                previousPeriodDate: previousPeriodContext?.date,
                hasOnlyShortTripsForPreviousPeriod: previousPeriodContext?.hasOnlyShortTrips ?? false,
                hasOnlyShortTripsForCurrentPeriod: currentPeriodContext?.hasOnlyShortTrips ?? false
            )
            
            self.communityCardViewModel.configure(
                with: scoreSynthesis,
                hasOnlyShortTripsForCurrentPeriod: currentPeriodContext?.hasOnlyShortTrips ?? false,
                userTripCount: currentPeriodContext?.numberTripTotal ?? 0,
                userDistanceCount: currentPeriodContext?.distance ?? 0,
                communityStatistics: communityStatistics ?? .default
            )
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
                startDate = Date().beginning(relativeTo: .year)
            @unknown default:
                startDate = nil
        }
        if let startDate {
            self.dateSelectorViewModel.configure(
                dates: [startDate],
                period: self.periodSelectorViewModel.selectedPeriod,
                selectedIndex: 0
            )
            
            self.scoreCardViewModel.configure(
                with: .init(scoreType: self.scoreSelectorViewModel.selectedScore),
                period: periodSelectorViewModel.selectedPeriod,
                previousPeriodDate: nil,
                hasOnlyShortTripsForPreviousPeriod: false,
                hasOnlyShortTripsForCurrentPeriod: false
            )
        }

        self.communityCardViewModel.configure(
            with: .init(scoreType: self.scoreSelectorViewModel.selectedScore),
            hasOnlyShortTripsForCurrentPeriod: false,
            userTripCount: 0,
            userDistanceCount: 0,
            communityStatistics: communityStatistics ?? .default
        )
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: oldPeriod,
            switchingAmongst: self.timelines[selectedPeriod]?.allDates ?? [],
            in: selectedPeriod
        ) { period, date in
            self.timelines[period]?.allContext[date: date]?.hasValue(
                for: scoreSelectorViewModel.selectedScore
            ) ?? false
        }
        update()
    }
}

extension MySynthesisViewModel: DKScoreSelectorDelegate {
    func scoreSelectorDidSelectScore(_ score: DKScoreType) {
        update()
    }
}

extension MySynthesisViewModel: DKPeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DKPeriod, to newPeriod: DKPeriod) {
        updateStateAfterSwitching(from: oldPeriod, to: newPeriod)
    }
}

extension MySynthesisViewModel: DKDateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        selectedDate = date
        update()
    }
}
