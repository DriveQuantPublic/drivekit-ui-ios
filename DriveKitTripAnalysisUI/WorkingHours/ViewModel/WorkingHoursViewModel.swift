// swiftlint:disable all
//
//  WorkingHoursViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 17/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitTripAnalysisModule
import AVFoundation

class WorkingHoursViewModel {
    private(set) var sections: [WorkingHoursSection] = []
    private let activatedSections: [WorkingHoursSection] = [
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
    weak var delegate: WorkingHoursViewModelDelegate?
    private var dayCellViewModelsByDay: [DKDay: WorkingHoursDayCellViewModel] = [:]
    private var slotViewModelByType: [SlotType: WorkingHoursSlotCellViewModel] = [:]
    private var workingHours: DKWorkingHours {
        didSet {
            self.update()
            self.hasModifications = false
        }
    }
    private(set) var hasModifications = false {
        didSet {
            self.delegate?.workingHoursDidModify()
        }
    }

    init() {
        self.workingHours = DriveKitTripAnalysisUI.shared.defaultWorkingHours.copy()
        self.update()
        DriveKitTripAnalysis.shared.getWorkingHours(type: .cache) { status, workingHours in
            if status == .cacheOnly, let workingHours = workingHours, self.areWorkingHoursValid(workingHours) {
                self.workingHours = workingHours
            }
        }
    }

    private func getWorkingHoursSlotCellViewModel(forType type: SlotType) -> WorkingHoursSlotCellViewModel {
        if let viewModel = self.slotViewModelByType[type] {
            return viewModel
        } else {
            let timeSlotStatus: DKWorkingHoursTimeSlotStatus
            switch type {
                case .inside:
                    timeSlotStatus = self.workingHours.insideHours
                case .outside:
                    timeSlotStatus = self.workingHours.outsideHours
            }
            let viewModel = WorkingHoursSlotCellViewModel(slotType: type, timeSlotStatus: timeSlotStatus)
            viewModel.delegate = self
            self.slotViewModelByType[type] = viewModel
            return viewModel
        }
    }

    func synchronizeWorkingHours() {
        DriveKitTripAnalysis.shared.getWorkingHours { [weak self] _, workingHours in
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

    func updateWorkingHours(completion: @escaping (Bool) -> Void) {
        DriveKitTripAnalysis.shared.updateWorkingHours(workingHours: self.workingHours) { status in
            let success = status == .success
            if success {
                DriveKitTripAnalysis.shared.getWorkingHours(type: .cache, completion: { [weak self] status, hours in
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

    func getSlotCellViewModel(type: SlotType) -> WorkingHoursSlotCellViewModel {
        return getWorkingHoursSlotCellViewModel(forType: type)
    }

    func getDayCellViewModel(day: DKDay) -> WorkingHoursDayCellViewModel {
        if let dayCellViewModel = self.dayCellViewModelsByDay[day] {
            return dayCellViewModel
        } else {
            let dayConfig = self.workingHours.workingHoursDayConfigurations.first(where: { $0.day == day }) ?? getDefaultConfig(day: day)
            let dayCellViewModel = WorkingHoursDayCellViewModel(config: dayConfig)
            dayCellViewModel.delegate = self
            self.dayCellViewModelsByDay[day] = dayCellViewModel
            return dayCellViewModel
        }
    }

    private func areWorkingHoursValid(_ workingHours: DKWorkingHours?) -> Bool {
        return !(workingHours?.workingHoursDayConfigurations.isEmpty ?? true)
    }

    private func update() {
        self.activate(workingHours.enabled)
        self.slotViewModelByType.removeAll()
        self.dayCellViewModelsByDay.removeAll()
        self.delegate?.workingHoursViewModelDidUpdate()
    }

    private func getDefaultConfig(day: DKDay) -> DKWorkingHoursDayConfiguration {
        let active = day != .saturday && day != .sunday
        return DKWorkingHoursDayConfiguration(day: day, entireDayOff: !active, startTime: 8, endTime: 18, reverse: false)
    }
}

extension WorkingHoursViewModel: WorkingHoursSlotCellViewModelDelegate {
    func workingHoursSlotCellViewModel(_ workingHoursSlotCellViewModel: WorkingHoursSlotCellViewModel, didUpdateTimeSlotStatus timeSlotStatus: DKWorkingHoursTimeSlotStatus, forType type: SlotType) {
        switch type {
            case .inside:
                self.workingHours.insideHours = timeSlotStatus
            case .outside:
                self.workingHours.outsideHours = timeSlotStatus
        }
        self.hasModifications = true
    }
}

extension WorkingHoursViewModel: WorkingHoursDayCellViewModelDelegate {
    func workingHoursDayCellViewModelDidUpdate(_ workingHoursDayCellViewModel: WorkingHoursDayCellViewModel) {
        self.hasModifications = true
    }
}

protocol WorkingHoursViewModelDelegate: AnyObject {
    func workingHoursViewModelDidUpdate()
    func workingHoursDidModify()
}

enum WorkingHoursSection {
    case separator
    case slot(SlotType)
    case day(DKDay)
}

enum SlotType {
    case inside
    case outside
}

extension DKWorkingHours {
    func copy() -> DKWorkingHours {
        if let data = try? JSONEncoder().encode(self), let copy = try? JSONDecoder().decode(DKWorkingHours.self, from: data) {
            return copy
        } else {
            return self
        }
    }
}
