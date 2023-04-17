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
    private let defaultContexts: [DKContextKind] = [
        .tripDistance,
        .week,
//        .road,
//        .weather,
        .dayNight
    ]
    let configuredPeriods: [DKPeriod] = [.week, .month, .year]
    weak var delegate: DrivingConditionsViewModelDelegate?
    weak var parentDelegate: DrivingConditionsViewModelParentDelegate?
    let periodSelectorViewModel: DKPeriodSelectorViewModel
    let dateSelectorViewModel: DKDateSelectorViewModel
    let drivingConditionsSummaryViewModel: DrivingConditionsSummaryCardViewModel
    private(set) var configuredContexts: [DKContextKind]
    private var timelines: [DKPeriod: DKDriverTimeline]
    private var selectedDate: Date?
    private(set) var updating: Bool = false
    private var contextViewModels: [DKContextKind: DKContextCard] = [:]
    private(set) var hasData: Bool = false
    private var drivingConditions: DKDriverTimeline.DKDrivingConditions?
    
    init(
        configuredContexts: [DKContextKind] = [],
        selectedPeriod: DKPeriod? = nil,
        selectedDate: Date? = nil
    ) {
        self.periodSelectorViewModel = DKPeriodSelectorViewModel()
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.drivingConditionsSummaryViewModel = DrivingConditionsSummaryCardViewModel()
        self.timelines = [:]
        self.selectedDate = selectedDate
        self.configuredContexts = configuredContexts.isEmpty ? self.defaultContexts : configuredContexts
        
        self.periodSelectorViewModel.delegate = self
        self.dateSelectorViewModel.delegate = self
        
        self.periodSelectorViewModel.configure(
            displayedPeriods: .init(configuredPeriods),
            selectedPeriod: selectedPeriod ?? .year
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
        
        if selectedPeriod == nil && selectedDate == nil {
            // if selectedPeriod and selectedDate are not nil
            // it means that we come from another screen like
            // MySynthesis which has already fetched live data and we
            // don't want to reset the date and period that comes
            // after such a refresh
            updateData()
        }
    }
    
    var shouldDisplayPagingController: Bool {
        configuredContexts.count > 1
    }
    
    var firstContext: DKContextKind {
        configuredContexts[0]
    }
    
    var numberOfContexts: Int {
        configuredContexts.count
    }
    
    func position(of context: DKContextKind) -> Int? {
        configuredContexts.firstIndex(of: context)
    }
    
    func context(at position: Int) -> DKContextKind? {
        guard configuredContexts.indexRange.contains(position) else {
            assertionFailure("We should not ask a context out of bounds")
            return nil
        }
        
        return configuredContexts[position]
    }
    
    func context(before context: DKContextKind) -> DKContextKind? {
        configuredContexts.firstIndex(of: context).flatMap {
            $0 > configuredContexts.startIndex ? configuredContexts[$0 - 1] : nil
        }
    }
    
    func context(after context: DKContextKind) -> DKContextKind? {
        configuredContexts.firstIndex(of: context).flatMap {
            $0 >= (configuredContexts.endIndex - 1) ? nil : configuredContexts[$0 + 1]
        }
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
                self.parentDelegate?.didUpdate(selectedDate: dateSelectorViewModel.selectedDate)
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
        if let currentContext = currentTimeline.allContext[date: self.dateSelectorViewModel.selectedDate] {
            self.drivingConditionsSummaryViewModel.configure(
                tripCount: currentContext.numberTripTotal,
                totalDistance: currentContext.distance
            )
            
            // TODO: create dict with roadContext:distance  + send it as parameter
            if let drivingConditions = currentContext.drivingConditions {
                self.drivingConditions = drivingConditions
                self.configureContextCards(drivingConditions: drivingConditions)
            }
        }
        
        self.hasData = true
    }

    private func configureContextCards(drivingConditions: DKDriverTimeline.DKDrivingConditions) {
        if let weekViewModel = self.contextViewModels[.week] as? WeekContextViewModel {
            weekViewModel.configure(with: drivingConditions)
        }
        if let dayNightViewModel = self.contextViewModels[.dayNight] as? DayNightContextViewModel {
            dayNightViewModel.configure(with: drivingConditions)
        }
        if let tripDistanceViewModel = self.contextViewModels[.tripDistance] as? TripDistanceContextViewModel {
            tripDistanceViewModel.configure(with: drivingConditions)
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
        
        self.drivingConditionsSummaryViewModel.configureWithNoData()
        self.hasData = false
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: oldPeriod,
            switchingAmongst: self.timelines[selectedPeriod]?.allDates ?? [],
            in: selectedPeriod
        ) { _, _ in true }
        update()
        parentDelegate?.didUpdate(selectedPeriod: selectedPeriod)
    }

    func getContextViewModel(for kind: DKContextKind) -> DKContextCard? {
        guard let drivingConditions else {
            return nil
        }
        switch kind {
            case .tripDistance:
                let tripDistanceViewModel: TripDistanceContextViewModel
                if let viewModel = self.contextViewModels[.tripDistance] as? TripDistanceContextViewModel {
                    tripDistanceViewModel = viewModel
                } else {
                    tripDistanceViewModel = TripDistanceContextViewModel()
                    self.contextViewModels[.tripDistance] = tripDistanceViewModel
                }
                tripDistanceViewModel.configure(with: drivingConditions)
            case .week:
                let weekViewModel: WeekContextViewModel
                if let viewModel = self.contextViewModels[.week] as? WeekContextViewModel {
                    weekViewModel = viewModel
                } else {
                    weekViewModel = WeekContextViewModel()
                    self.contextViewModels[.week] = weekViewModel
                }
                weekViewModel.configure(with: drivingConditions)
            case .road:
                //
                break
            case .weather:
                //
                break
            case .dayNight:
                let dayNightViewModel: DayNightContextViewModel
                if let viewModel = self.contextViewModels[.dayNight] as? DayNightContextViewModel {
                    dayNightViewModel = viewModel
                } else {
                    dayNightViewModel = DayNightContextViewModel()
                    self.contextViewModels[.dayNight] = dayNightViewModel
                }
                dayNightViewModel.configure(with: drivingConditions)
        }
        return self.contextViewModels[kind]
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
        parentDelegate?.didUpdate(selectedDate: date)
    }
}
