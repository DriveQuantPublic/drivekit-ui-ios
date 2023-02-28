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
    let horizontalGaugeViewModel = HorizontalGaugeViewModel()
    private var timelines: [DKPeriod: DKDriverTimeline]
    private var selectedDate: Date?
    private(set) var updating: Bool = false
    
    var shouldHideDetailButton: Bool {
        return true
    }
    
    init() {
        self.scoreSelectorViewModel = DKScoreSelectorViewModel()
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
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
        self.dateSelectorViewModel.configure(
            dates: allDates,
            period: currentTimeline.period,
            selectedIndex: allDates.selectedIndex(for: selectedDate)
        )
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
        }
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: self.timelines[oldPeriod]?.periodDates ?? .init(period: oldPeriod),
            switchingTo: self.timelines[selectedPeriod]?.periodDates ?? .init(period: selectedPeriod)
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
