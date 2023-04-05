//
//  DrivingConditionsViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import Foundation

class DrivingConditionsViewModel {
    let configuredPeriods: [DKPeriod] = [.week, .month, .year]
    weak var delegate: DrivingConditionsViewModelDelegate?
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    private var timelines: [DKPeriod: DKDriverTimeline]
    private var selectedDate: Date?
    private(set) var updating: Bool = false
    
    init() {
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.timelines = [:]
        self.selectedDate = nil
        
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
                self.updating = false
                self.update(resettingSelectedDate: true)
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
        
        if allDates.isEmpty {
            configureWithNoData()
            return
        }
        
        let selectedDateIndex = allDates.selectedIndex(for: selectedDate)
        self.dateSelectorViewModel.configure(
            dates: allDates,
            period: currentTimeline.period,
            selectedIndex: selectedDateIndex
        )
        
        self.selectedDate = self.dateSelectorViewModel.selectedDate
        if
            let selectedDate,
            let previousPeriodContext = currentTimeline.allContext.previousValidItem(
                from: selectedDate
            ),
            let currentPeriodContext = currentTimeline.allContext[date: selectedDate] {
                
            #warning("is it still useful?")
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
            
        }
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: oldPeriod,
            switchingAmongst: self.timelines[selectedPeriod]?.allDates ?? [],
            in: selectedPeriod
        ) { _, _ in true }
        update()
    }
}

extension DrivingConditionsViewModel: DKPeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DKPeriod, to newPeriod: DKPeriod) {
        updateStateAfterSwitching(from: oldPeriod, to: newPeriod)
    }
}

extension DrivingConditionsViewModel: DKDateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        selectedDate = date
        update()
    }
}
