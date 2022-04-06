//
//  WorkingHoursSlotCellViewModel.swift
//  DriveKitTripAnalysisUI
//
//  Created by David Bauduin on 04/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI
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

    func getSlotColor() -> UIColor {
        switch self.slotType {
            case .inside:
                return DKUIColors.secondaryColor.color
            case .outside:
                return DKUIColors.neutralColor.color
        }
    }
}

protocol WorkingHoursSlotCellViewModelDelegate: AnyObject {
    func workingHoursSlotCellViewModel(_ workingHoursSlotCellViewModel: WorkingHoursSlotCellViewModel, didUpdateTimeSlotStatus timeSlotStatus: DKWorkingHoursTimeSlotStatus, forType type: SlotType)
}
