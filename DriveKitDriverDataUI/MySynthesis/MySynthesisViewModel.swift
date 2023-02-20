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
    let scoreSelectorViewModel: ScoreSelectorViewModel
    let periodSelectorViewModel: PeriodSelectorViewModel
    let dateSelectorViewModel: DateSelectorViewModel
    private var timelines: [DKPeriod: DKDriverTimeline]
    
    init() {
        self.scoreSelectorViewModel = ScoreSelectorViewModel()
        self.periodSelectorViewModel = PeriodSelectorViewModel()
        self.dateSelectorViewModel = DateSelectorViewModel()
        self.timelines = [:]

        self.scoreSelectorViewModel.delegate = self
        self.periodSelectorViewModel.delegate = self
        self.dateSelectorViewModel.delegate = self
        
        DriveKitDriverData.shared.getDriverTimelines(
            periods: [.week, .month, .year],
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
    
    private func update() {
        
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.dateSelectorViewModel.selectedDate = DateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: self.timelines[oldPeriod]?.periodDates ?? .init(period: oldPeriod),
            switchingTo: self.timelines[selectedPeriod]?.periodDates ?? .init(period: selectedPeriod)
        )
        update()
    }
}

extension MySynthesisViewModel: ScoreSelectorDelegate {
    func scoreSelectorDidSelectScore(_ score: DKScoreType) {
        update()
    }
}

extension MySynthesisViewModel: PeriodSelectorDelegate {
    func periodSelectorDidSwitch(from oldPeriod: DKPeriod, to newPeriod: DKPeriod) {
        updateStateAfterSwitching(from: oldPeriod, to: newPeriod)
    }
}

extension MySynthesisViewModel: DateSelectorDelegate {
    func dateSelectorDidSelectDate(_ date: Date) {
        update()
    }
}
