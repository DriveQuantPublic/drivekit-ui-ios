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
        .separator,
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
    private(set) var isActivated = false
    weak var delegate: DKActivationHoursConfigDelegate? = nil
    private var dayCellViewModelsByDay: [DKDay: ActivationHoursDayCellViewModel] = [:]
    private var slotViewModelByType: [SlotType: ActivationHoursSlotCellViewModel] = [
        .inside: ActivationHoursSlotCellViewModel(slotType: .inside, tripStatus: .business),
        .outside: ActivationHoursSlotCellViewModel(slotType: .outside, tripStatus: .disabled)
    ]
    private var activationHours: DKActivationHours?

    init() {
        DriveKitTripAnalysis.shared.getActivationHours(type: .cache) { status, activationHours in
            if status == .cacheOnly, let activationHours = activationHours {
                self.activate(activationHours.enabled)
                self.getActivationHoursSlotCellViewModel(forType: .inside).tripStatus = activationHours.insideHours
                self.getActivationHoursSlotCellViewModel(forType: .outside).tripStatus = activationHours.outsideHours
            }
        }
    }

    private func getActivationHoursSlotCellViewModel(forType type: SlotType) -> ActivationHoursSlotCellViewModel {
        if let viewModel = self.slotViewModelByType[type] {
            return viewModel
        } else {
            let defaultTripStatus: TripStatus
            switch type {
                case .inside:
                    defaultTripStatus = .business
                case .outside:
                    defaultTripStatus = .disabled
            }
            let viewModel = ActivationHoursSlotCellViewModel(slotType: type, tripStatus: defaultTripStatus)
            self.slotViewModelByType[type] = viewModel
            return viewModel
        }
    }

    func synchronizeActivationHours() {
        self.delegate?.showLoader()
        DriveKitTripAnalysis.shared.getActivationHours { [weak self] status, activationHours in
            if let self = self {
                self.activationHours = activationHours
                if status == .success {
                    self.delegate?.hideLoader()
                    self.delegate?.onActivationHoursAvaiblale()
                } else {
                    self.delegate?.didReceiveErrorFromService()
                }
            }
        }
    }

//    func buildActivationHours() -> DKActivationHours {
//        return DKActivationHours(
//            enabled: <#T##Bool#>,
//            activationHoursDayConfigurations: <#T##[DKActivationHoursDayConfiguration]#>,
//            outsideHours: <#T##Bool#>)
//    }

    func activate(_ activate: Bool) {
        if self.isActivated != activate {
            self.isActivated = activate
            if activate {
                self.sections = self.activatedSections
            } else {
                self.sections = []
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
            let select = day != .saturday && day != .sunday
            let dayCellViewModel = ActivationHoursDayCellViewModel(day: day, selected: select)
            self.dayCellViewModelsByDay[day] = dayCellViewModel
            return dayCellViewModel
        }
    }
}

public protocol DKActivationHoursConfigDelegate: AnyObject {
    func onActivationHoursAvaiblale()
    func onActivationHoursUpdated()
    func didReceiveErrorFromService()
    func showLoader()
    func hideLoader()
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
