//
//  WorkingHoursSlotCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation

import DriveKitTripAnalysisModule

class WorkingHoursSlotCellViewModel {
    let slotType: SlotType
    var timeSlotStatus: DKWorkingHoursTimeSlotStatus {
        didSet {
            if oldValue != self.timeSlotStatus {
                self.delegate?.workingHoursSlotCellViewModel(self, didUpdateTimeSlotStatus: self.timeSlotStatus, forType: self.slotType)
            }
        }
    }
    weak var delegate: WorkingHoursSlotCellViewModelDelegate?

    init(slotType: SlotType, timeSlotStatus: DKWorkingHoursTimeSlotStatus) {
        self.slotType = slotType
        self.timeSlotStatus = timeSlotStatus
    }
}

protocol WorkingHoursSlotCellViewModelDelegate: AnyObject {
    func workingHoursSlotCellViewModel(_ workingHoursSlotCellViewModel: WorkingHoursSlotCellViewModel, didUpdateTimeSlotStatus timeSlotStatus: DKWorkingHoursTimeSlotStatus, forType type: SlotType)
}
