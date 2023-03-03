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
    private var timelines: [DKPeriod: DKDriverTimeline]
    private var selectedDate: Date?
    private(set) var updating: Bool = false
    
    var shouldHideDetailButton: Bool {
        #warning("Temporarily set it to false to display score legend")
        return false
    }
    
    init() {
        self.scoreSelectorViewModel = DKScoreSelectorViewModel()
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.scoreCardViewModel = MySynthesisScoreCardViewModel()
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
            if let self {
                if status == .cacheDataOnly, let timelines {
                    self.timelines = timelines.reduce(into: [:]) { resultSoFar, timeline in
                        resultSoFar[timeline.period] = timeline
                    }
                    self.update()
                }
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
            if let self {
                if status != .noTimelineYet, let timelines {
                    self.timelines = timelines.reduce(into: [:]) { resultSoFar, timeline in
                        resultSoFar[timeline.period] = timeline
                    }
                    self.update(resettingSelectedDate: true)
                }
                self.updating = false
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
        let allDates = currentTimeline.allContext.map(\.date)
        let selectedDateIndex = allDates.selectedIndex(for: selectedDate)
        self.dateSelectorViewModel.configure(
            dates: allDates,
            period: currentTimeline.period,
            selectedIndex: selectedDateIndex
        )
        self.selectedDate = self.dateSelectorViewModel.selectedDate
        if
            let selectedDateIndex,
            let scoreSynthesis = currentTimeline.driverScoreSynthesis(
            for: scoreSelectorViewModel.selectedScore,
            at: dateSelectorViewModel.selectedDate
        ) {
            let previousPeriodContext = currentTimeline.allContext[safe: selectedDateIndex - 1]
            let currentPeriodContext = currentTimeline.allContext[safe: selectedDateIndex]
            self.scoreCardViewModel.configure(
                with: scoreSynthesis,
                period: periodSelectorViewModel.selectedPeriod,
                previousPeriodDate: previousPeriodContext?.date,
                hasOnlyShortTripsForPreviousPeriod: previousPeriodContext?.hasOnlyShortTrips ?? false,
                hasOnlyShortTripsForCurrentPeriod: currentPeriodContext?.hasOnlyShortTrips ?? false
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
        
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: oldPeriod,
            switchingAmongst: self.timelines[selectedPeriod]?.allDates ?? []
        )
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
