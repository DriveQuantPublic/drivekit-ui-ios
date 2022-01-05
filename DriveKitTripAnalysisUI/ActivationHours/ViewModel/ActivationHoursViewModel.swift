//
//  ActivationHoursViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 17/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule
import AVFoundation

class ActivationHoursViewModel {
    private(set) var sections: [ActivationHoursSection] = []
    private let activatedSections: [ActivationHoursSection] = [
        .slot(.inside),
        .separator,
        .slot(.outside),
        .separator,
        .day(.monday),
        .day(.tuesday),
        .day(.wednesday),
        .day(.thursday),
        .day(.friday),
        .day(.saturday),
        .day(.sunday)
    ]
    var isActivated: Bool {
        get {
            return self.workingHours.enabled
        }
    }
    weak var delegate: WorkingHoursViewModelDelegate? = nil
    private var dayCellViewModelsByDay: [DKDay: ActivationHoursDayCellViewModel] = [:]
    private var slotViewModelByType: [SlotType: ActivationHoursSlotCellViewModel] = [:]
    private var workingHours: DKActivationHours {
        didSet {
            self.hasModifications = false
            self.update()
        }
    }
    private(set) var hasModifications = false {
        didSet {
            self.delegate?.workingHoursDidModify()
        }
    }

    init() {
        self.workingHours = DriveKitTripAnalysisUI.shared.defaultWorkingHours
        DriveKitTripAnalysis.shared.getActivationHours(type: .cache) { status, workingHours in
            if status == .cacheOnly, let workingHours = workingHours, self.areWorkingHoursValid(workingHours) {
                self.workingHours = workingHours
            }
        }
    }

    private func getActivationHoursSlotCellViewModel(forType type: SlotType) -> ActivationHoursSlotCellViewModel {
        if let viewModel = self.slotViewModelByType[type] {
            return viewModel
        } else {
            let tripStatus: TripStatus
            switch type {
                case .inside:
                    tripStatus = self.workingHours.insideHours
                case .outside:
                    tripStatus = self.workingHours.outsideHours
            }
            let viewModel = ActivationHoursSlotCellViewModel(slotType: type, tripStatus: tripStatus)
            viewModel.delegate = self
            self.slotViewModelByType[type] = viewModel
            return viewModel
        }
    }

    func synchronizeActivationHours() {
        DriveKitTripAnalysis.shared.getActivationHours { [weak self] status, workingHours in
            if let self = self {
                DispatchQueue.dispatchOnMainThread {
                    if let workingHours = workingHours, self.areWorkingHoursValid(workingHours) {
                        self.workingHours = workingHours
                    } else {
                        self.delegate?.workingHoursViewModelDidUpdate()
                    }
                }
            }
        }
    }

    func updateWorkingHours(completion: @escaping (Bool) -> ()) {
        DriveKitTripAnalysis.shared.updateActivationHours(activationHours: self.workingHours) { status in
            let success = status == .success
            if success {
                DriveKitTripAnalysis.shared.getActivationHours(type: .cache, completion: { [weak self] status, hours in
                    if let self = self {
                        DispatchQueue.dispatchOnMainThread {
                            if status == .cacheOnly, let hours = hours {
                                self.workingHours = hours
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    }
                })
            } else {
                completion(false)
            }
        }
    }

    func activate(_ activate: Bool) {
        self.workingHours.enabled = activate
        if activate {
            if self.sections.count != self.activatedSections.count {
                self.sections = self.activatedSections
                self.hasModifications = true
            }
        } else {
            if !self.sections.isEmpty {
                self.sections = []
                self.hasModifications = true
            }
        }
    }

    func getSlotCellViewModel(type: SlotType) -> ActivationHoursSlotCellViewModel {
        return getActivationHoursSlotCellViewModel(forType: type)
    }

    func getDayCellViewModel(day: DKDay) -> ActivationHoursDayCellViewModel {
        if let dayCellViewModel = self.dayCellViewModelsByDay[day] {
            return dayCellViewModel
        } else {
            let dayConfig = self.workingHours.activationHoursDayConfigurations.first(where: { $0.day == day }) ?? getDefaultConfig(day: day)
            let dayCellViewModel = ActivationHoursDayCellViewModel(config: dayConfig)
            dayCellViewModel.delegate = self
            self.dayCellViewModelsByDay[day] = dayCellViewModel
            return dayCellViewModel
        }
    }

    private func areWorkingHoursValid(_ workingHours: DKActivationHours?) -> Bool {
        return !(workingHours?.activationHoursDayConfigurations.isEmpty ?? true)
    }

    private func update() {
        self.activate(workingHours.enabled)
        self.slotViewModelByType.removeAll()
        self.dayCellViewModelsByDay.removeAll()
        self.delegate?.workingHoursViewModelDidUpdate()
    }

    private func getDefaultConfig(day: DKDay) -> DKActivationHoursDayConfiguration {
        let active = day != .saturday && day != .sunday
        return DKActivationHoursDayConfiguration(day: day, entireDayOff: !active, startTime: 8, endTime: 18, reverse: false)
    }
}

extension ActivationHoursViewModel: ActivationHoursSlotCellViewModelDelegate {
    func activationHoursSlotCellViewModel(_ activationHoursSlotCellViewModel: ActivationHoursSlotCellViewModel, didUpdateTripStatus tripStatus: TripStatus, forType type: SlotType) {
        switch type {
            case .inside:
                self.workingHours.insideHours = tripStatus
            case .outside:
                self.workingHours.outsideHours = tripStatus
        }
        self.hasModifications = true
    }
}

extension ActivationHoursViewModel: ActivationHoursDayCellViewModelDelegate {
    func activationHoursDayCellViewModelDidUpdate(_ activationHoursDayCellViewModel: ActivationHoursDayCellViewModel) {
        self.hasModifications = true
    }
}

public protocol WorkingHoursViewModelDelegate: AnyObject {
    func workingHoursViewModelDidUpdate()
    func workingHoursDidModify()
}

enum ActivationHoursSection {
    case separator
    case slot(SlotType)
    case day(DKDay)
}

enum SlotType {
    case inside
    case outside
}
