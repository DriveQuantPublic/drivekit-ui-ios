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
    private let defaultContexts: [DKContextKind] = DriveKitUI.shared.unitSystem == .metric ? [
        .tripDistance,
        .week,
        .road,
        .weather,
        .dayNight
    ] : [
        .week,
        .road,
        .weather,
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
    private var distanceByRoadContext: [DKRoadContext: Double] = [:]
    private var totalDistance: Double = 0.0

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
            }
            
            self.updating = false
            self.update(resettingSelectedDate: true)
            self.delegate?.didUpdateData()
            self.parentDelegate?.didUpdate(selectedDate: self.dateSelectorViewModel.selectedDate)
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
        guard
            let currentContext = currentTimeline.allContext[date: self.dateSelectorViewModel.selectedDate],
            let drivingConditions = currentContext.drivingConditions
        else {
            configureWithNoData()
            return
        }
        
        totalDistance = currentContext.distance
        self.drivingConditionsSummaryViewModel.configure(
            tripCount: currentContext.numberTripTotal,
            totalDistance: currentContext.distance
        )
        
        let distanceByRoadContext = currentTimeline.distanceByRoadContext(for: self.dateSelectorViewModel.selectedDate)
        self.distanceByRoadContext = distanceByRoadContext
        
        self.drivingConditions = drivingConditions
        for contextKind in configuredContexts {
            if let viewModel = self.contextViewModels[contextKind] as? DrivingConditionsContextCard {
                self.configureContextViewModel(viewModel, of: contextKind)
            }
        }
        self.hasData = true
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
        
        self.totalDistance = 0.0
        self.distanceByRoadContext = [:]
        self.drivingConditions = nil
        self.drivingConditionsSummaryViewModel.configureWithNoData()
        self.hasData = false
    }
    
    private func updateStateAfterSwitching(from oldPeriod: DKPeriod, to selectedPeriod: DKPeriod) {
        self.selectedDate = DKDateSelectorViewModel.newSelectedDate(
            from: self.dateSelectorViewModel.selectedDate,
            in: oldPeriod,
            switchingAmongst: self.timelines[selectedPeriod]?.allDates ?? [],
            in: selectedPeriod
        )
        update()
        parentDelegate?.didUpdate(selectedPeriod: selectedPeriod)
    }

    private func configureContextViewModel(_ contextViewModel: DrivingConditionsContextCard, of kind: DKContextKind) {
        if kind == .road {
            contextViewModel.configureAsRoadContext(
                with: distanceByRoadContext,
                realTotalDistance: totalDistance
            )
            return
        }
        
        guard let drivingConditions else {
            return
        }
        
        switch kind {
            case .tripDistance:
                contextViewModel.configureAsTripDistanceContext(with: drivingConditions)
            case .week:
                contextViewModel.configureAsWeekContext(with: drivingConditions)
            case .weather:
                contextViewModel.configureAsWeatherContext(with: drivingConditions)
            case .dayNight:
                contextViewModel.configureAsDayNightContext(with: drivingConditions)
            case .road:
                preconditionFailure("Should be managed before unwrapping drivingContitions")
        }
        
    }
    
    private func contextViewModel<T: DKContextCard>(for contextKind: DKContextKind, _ createVM: () -> T) -> T {
        let contextViewModel: T
        if let viewModel = self.contextViewModels[contextKind] as? T {
            contextViewModel = viewModel
        } else {
            contextViewModel = createVM()
            self.contextViewModels[contextKind] = contextViewModel
        }
        return contextViewModel
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

extension DKDriverTimeline {
    func distanceByRoadContext(for selectedDate: Date) -> [DKRoadContext: Double] {
        var distanceByRoadContext: [DKRoadContext: Double] = [:]
        for roadContext in self.roadContexts {
            let type = roadContext.key
            let distance = roadContext.value[date: selectedDate]?.distance
            distanceByRoadContext[type] = distance
        }
        return distanceByRoadContext
    }
}

extension DrivingConditionsViewModel: DKUIPagingViewModel {
    var allPageIds: [DKContextKind] {
        configuredContexts
    }
    
    func pageViewModel(for pageId: DKContextKind) -> DKContextCard? {
        if pageId != .road && drivingConditions == nil {
            return nil
        }
        
        let viewModel = self.contextViewModel(for: pageId) {
            DrivingConditionsContextCard()
        }
        
        self.configureContextViewModel(viewModel, of: pageId)
        
        return viewModel
    }
}
